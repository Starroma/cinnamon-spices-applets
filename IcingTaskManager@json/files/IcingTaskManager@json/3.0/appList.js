'use strict';

var Lang = imports.lang;
var Cinnamon = imports.gi.Cinnamon;
var Clutter = imports.gi.Clutter;
var St = imports.gi.St;
var Gio = imports.gi.Gio;
var _ = imports.applet._;
var clog = imports.applet.clog;
var setTimeout = imports.applet.setTimeout;

var AppletDir = imports.ui.appletManager.applets['IcingTaskManager@json'];
var App = AppletDir.applet;
var AppGroup = AppletDir.appGroup;

// List of running apps

function AppList() {
  this._init.apply(this, arguments);
}

/*



MyApplet._init, signal (switch-workspace) -> _onSwitchWorkspace -> AppList



*/

AppList.prototype = {
  _init: function _init(applet, metaWorkspace) {
    this._applet = applet;
    this.metaWorkspace = metaWorkspace;
    this.actor = new St.BoxLayout();

    var manager;
    if (this.orientation == St.Side.TOP || this.orientation == St.Side.BOTTOM) {
      manager = new Clutter.BoxLayout({ orientation: Clutter.Orientation.HORIZONTAL });
    } else {
      manager = new Clutter.BoxLayout({ orientation: Clutter.Orientation.VERTICAL });
      this.actor.add_style_class_name('vertical');
      this._applet.actor.add_style_class_name('vertical');
    }

    this.manager = manager;
    this.manager_container = new Clutter.Actor({ layout_manager: manager });
    this.actor.add_actor(this.manager_container);

    this._appsys = Cinnamon.AppSystem.get_default();
    this.registeredApps = [];

    this.appList = [];
    this.lastFocusedApp = null;

    // Connect all the signals
    this._setSignals();
    this._refreshList(true);

    this.actor.connect('style-changed', Lang.bind(this, this._updateSpacing));

    this.on_orientation_changed(this._applet.orientation, true);
  },

  on_panel_edit_mode_changed: function on_panel_edit_mode_changed() {
    this.actor.reactive = global.settings.get_boolean('panel-edit-mode');
  },

  on_applet_added_to_panel: function on_applet_added_to_panel(userEnabled) {
    this._updateSpacing();
    this._applet.appletEnabled = true;
  },

  on_orientation_changed: function on_orientation_changed(orientation) {
    var init = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;

    if (this.manager === undefined) {
      return;
    }
    this._applet.orientation = orientation;

    // Any padding/margin is removed on one side so that the AppMenuButton
    // boxes butt up against the edge of the screen

    var containerChildren = this.manager_container.get_children();

    var orientationKey = null;
    _.each(St.Side, function (side, key) {
      if (orientation === St.Side[key]) {
        orientationKey = key.toLowerCase();
        return;
      }
    });

    var style = 'margin-' + orientationKey + ': 0px; padding-' + orientationKey + ': 0px;';
    var isVertical = orientationKey === 'left' || orientationKey === 'right';

    if (isVertical) {
      this.manager.set_vertical(true);
      this.actor.add_style_class_name('vertical');
      this.actor.set_x_align(Clutter.ActorAlign.CENTER);
      this.actor.set_important(true);
      var opposite = orientationKey === 'left' ? 'right' : 'left';
      style += 'padding-' + opposite + ': 0px; margin-' + opposite + ': 0px;';
    } else {
      this.manager.set_vertical(false);
      this.actor.remove_style_class_name('vertical');
      this._applet.actor.remove_style_class_name('vertical');
    }

    if (!init) {
      this._applet.settings.setValue('vertical-thumbnails', isVertical);
    }

    _.each(containerChildren, function (child, key) {
      child.set_style(style);
      if (isVertical) {
        child.set_x_align(Clutter.ActorAlign.CENTER);
      }
    });
    this.actor.set_style(style);

    if (this._applet.appletEnabled) {
      this._updateSpacing();
    }
  },

  _updateSpacing: function _updateSpacing() {
    this.manager.set_spacing(this._applet.iconSpacing * global.ui_scale);
  },

  _setSignals: function _setSignals() {
    this.signals = [];
    // We use connect_after so that the window-tracker time to identify the app
    this.signals.push(this.metaWorkspace.connect_after('window-added', Lang.bind(this, this._windowAdded)));
    this.signals.push(this.metaWorkspace.connect_after('window-removed', Lang.bind(this, this._windowRemoved)));

    this._applet.settings.connect('changed::show-pinned', Lang.bind(this, this._refreshList));
    this._applet.settings.connect('changed::icon-spacing', Lang.bind(this, this._updateSpacing));
    global.settings.connect('changed::panel-edit-mode', Lang.bind(this, this.on_panel_edit_mode_changed));
  },

  _setLastFocusedApp: function _setLastFocusedApp(id) {
    this.lastFocusedApp = id;
  },


  // Gets a list of every app on the current workspace

  _getSpecialApps: function _getSpecialApps() {
    this.specialApps = [];
    var apps = Gio.app_info_get_all();

    for (var i = 0, len = apps.length; i < len; i++) {
      var wmClass = apps[i].get_startup_wm_class();
      if (wmClass) {
        var id = apps[i].get_id();
        this.specialApps.push({ id: id, wmClass: wmClass });
      }
    }
  },

  _refreshList: function _refreshList() {
    var init = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;

    for (var i = 0, len = this.appList.length; i < len; i++) {
      this.appList[i].appGroup.destroy();
    }

    this.appList = [];
    this.registeredApps = this._getSpecialApps();
    this._loadFavorites(init);
    this._refreshApps(init);
  },

  /*
    Refresh specific apps by finding their index, destroying, and recreating them.
  */

  _refreshAppById: function _refreshAppById(appId, opts) {
    var refApp = _.findIndex(this.appList, { id: appId });
    if (refApp !== -1) {
      var app = this.appList[refApp].appGroup.app;
      var isFavapp = opts.favChange ? opts.isFavapp : this.appList[refApp].appGroup.isFavapp;
      var index = this.appList[refApp].ungroupedIndex;

      this.appList[refApp].appGroup.destroy();

      var windows = app.get_windows();

      var window = null;
      var hasWindows = windows.length > 0;

      if (!isFavapp && !hasWindows && opts.favChange) {
        _.pullAt(this.appList, refApp);
        return;
      }

      if (!this._applet.groupApps) {
        window = app.get_windows()[0];
      }

      var time = Date.now();

      var appGroup = new AppGroup.AppGroup(this._applet, this, app, isFavapp, window, time, index);

      appGroup._updateMetaWindows(this.metaWorkspace, app, window);
      appGroup.watchWorkspace(this.metaWorkspace);
      appGroup.isFavapp = isFavapp;

      this.appList[refApp].appGroup = appGroup;
      this.appList[refApp].time = time;

      var refPos = opts.favPos ? opts.favPos : refApp;
      this.manager_container.set_child_at_index(appGroup.actor, refPos);
    } else if (opts.favChange) {
      this._applet.refreshCurrentAppList();
    }
  },


  _loadFavorites: function _loadFavorites(init) {
    if (!this._applet.settings.getValue('show-pinned')) {
      return;
    }
    var launchers = this._applet.pinned_app_contr()._getIds();

    for (var i = 0, len = launchers.length; i < len; i++) {
      var app = this._appsys.lookup_app(launchers[i]);
      if (!app) {
        app = this._appsys.lookup_settings_app(launchers[i]);
      }
      if (!app) {
        continue;
      }
      this._windowAdded(this.metaWorkspace, null, app, true);
    }
  },

  _refreshApps: function _refreshApps(init) {
    var windows = this.metaWorkspace.list_windows();

    for (var i = 0, len = windows.length; i < len; i++) {
      this._windowAdded(this.metaWorkspace, windows[i], null, null);
    }
  },

  _windowAdded: function _windowAdded(metaWorkspace, metaWindow, favapp, isFavapp) {
    var _this = this;

    var forceUngroupedWindow = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : false;

    // Check to see if the window that was added already has an app group.
    // If it does, then we don't need to do anything.  If not, we need to
    // create an app group.
    var app = null;
    if (favapp) {
      app = favapp;
    } else {
      app = App.appFromWMClass(this._appsys, this.specialApps, metaWindow);
    }
    if (!app) {
      app = this._applet.tracker.get_window_app(metaWindow);
    }
    if (!app) {
      return;
    }

    var appId = app.get_id();
    var refApp = _.findIndex(this.appList, { id: appId });

    // If forceUngroupedWindow is set, then this method is being called from the first appGroup instance for this app, to override app grouping.
    if (forceUngroupedWindow && !favapp) {
      refApp = -1;
    }

    var initApp = function initApp() {
      var window = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : null;
      var index = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;

      var time = Date.now();
      var appGroup = new AppGroup.AppGroup(_this._applet, _this, app, isFavapp, window, time, index, appId);
      appGroup._updateMetaWindows(metaWorkspace, app, window);
      appGroup.watchWorkspace(metaWorkspace); // disable for windows to stay persistent across ws'

      app.connect_after('windows-changed', Lang.bind(_this, _this._onAppWindowsChanged, app));

      _this.appList.push({
        id: appId,
        appGroup: appGroup,
        timeStamp: time,
        ungroupedIndex: index
      });

      var appGroupNum = _this._appGroupNumber(app);
      appGroup._newAppKeyNumber(appGroupNum);

      if (_this._applet.settings.getValue('title-display') === App.TitleDisplay.Focused) {
        appGroup.hideAppButtonLabel(false);
      }
    };

    if (refApp === -1) {
      if (this._applet.groupApps || forceUngroupedWindow && !favapp) {
        initApp();
      } else {
        var windows = app.get_windows();
        var _windows = windows.length > 0 ? windows : [null];

        for (var i = 0, len = _windows.length; i < len; i++) {
          initApp(_windows[i], i);
        }
      }
    }
  },

  _appGroupNumber: function _appGroupNumber(parentApp) {
    var result;
    for (var i = 0, len = this.appList.length; i < len; i++) {
      if (this.appList[i].appGroup.app === parentApp) {
        result = i + 1;
        break;
      }
    }
    return result;
  },

  _onAppWindowsChanged: function _onAppWindowsChanged(app) {
    var numberOfwindows = this._getNumberOfAppWindowsInWorkspace(app, this.metaWorkspace);
    if (!numberOfwindows || numberOfwindows === 0) {
      this._removeApp(app);
      this._calcAllWindowNumbers();
    }
  },

  _calcAllWindowNumbers: function _calcAllWindowNumbers() {
    for (var i = 0, len = this.appList.length; i < len; i++) {
      this.appList[i].appGroup._calcWindowNumber(this.metaWorkspace);
    }
  },

  _getNumberOfAppWindowsInWorkspace: function _getNumberOfAppWindowsInWorkspace(app, workspace) {
    var windows = app.get_windows();

    var result = 0;

    for (var i = 0, len = windows.length; i < len; i++) {
      var windowWorkspace = windows[i].get_workspace();
      if (windowWorkspace.index() === workspace.index()) {
        ++result;
      }
    }
    return result;
  },

  _refreshAppGroupNumber: function _refreshAppGroupNumber() {
    for (var i = 0, len = this.appList.length; i < len; i++) {
      this.appList[i].appGroup._newAppKeyNumber(i + 1);
    }
  },

  _windowRemoved: function _windowRemoved(metaWorkspace, metaWindow) {
    var app = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;


    // When a window is closed, we need to check if the app it belongs
    // to has no windows left.  If so, we need to remove the corresponding AppGroup
    if (!app) {
      app = App.appFromWMClass(this._appsys, this.specialApps, metaWindow);

      if (!app) {
        app = this._applet.tracker.get_window_app(metaWindow);
      }
      if (!app) {
        return;
      }
    }
    var hasWindowsOnWorkspace = void 0;
    if (app.wmClass) {
      hasWindowsOnWorkspace = metaWorkspace.list_windows().some(function (win) {
        return app.wmClass == win.get_wm_class_instance();
      });
    } else {
      hasWindowsOnWorkspace = app.get_windows().some(function (win) {
        return win.get_workspace() == metaWorkspace;
      });
    }

    if (app && !hasWindowsOnWorkspace) {
      this._removeApp(app);
    }
  },

  _removeApp: function _removeApp(app) {
    var _this2 = this;

    var timeStamp = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : null;

    // This function may get called multiple times on the same app and so the app may have already been removed
    var refApp = -1;
    if (this._applet.groupApps || !timeStamp) {
      refApp = _.findIndex(this.appList, { id: app.get_id() });
    } else if (timeStamp) {
      refApp = _.findIndex(this.appList, function (_app) {
        return _app.timeStamp === timeStamp;
      });
    }
    if (refApp !== -1) {
      if ((this.appList[refApp].appGroup.wasFavapp || this.appList[refApp].appGroup.isFavapp) && !timeStamp) {
        this.appList[refApp].appGroup._isFavorite(true);

        this._refreshApps();
        return;
      }

      this.appList[refApp].appGroup.destroy();
      _.pullAt(this.appList, refApp);

      setTimeout(function () {
        _this2._refreshAppGroupNumber();
      }, 15);
    }
  },

  destroy: function destroy() {
    for (var i = 0, len = this.signals.length; i < len; i++) {
      this.metaWorkspace.disconnect(this.signals[i]);
    }
    for (var _i = 0, _len = this.appList.length; _i < _len; _i++) {
      this.appList[_i].appGroup.destroy();
    }
    this.appList.destroy();
    this.appList = null;
  }
};