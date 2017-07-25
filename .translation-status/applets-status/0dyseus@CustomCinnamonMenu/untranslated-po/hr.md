# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@CustomCinnamonMenu](../README.md) &#187; **Croatian (hr)**

       1	Description
       2	This applet is a custom version of the default Cinnamon Menu applet, but infinitely more customizable.
       3	Added options/features
       4	All mayor elements of the menu can be hidden or placed anywhere on the menu.
       5	Added Fuzzy search. Based on [Sane Menu](https://cinnamon-spices.linuxmint.com/applets/view/258s) applet by **nooulaif**.
       6	Added a custom launchers box that can run any command/script/file and can be placed at the top/bottom of the menu or to the left/right of the searchbox.
       7	Custom launchers icons can have a custom size and can be symbolic or full color.
       8	Custom launchers can execute any command (as entered in a terminal) or a path to a file. If the file is an executable script, an attempt to execute it will be made. Otherwise, the file will be opened with the systems handler for that file type.
       9	The **Quit buttons** can now be moved next the the custom launchers box and can have custom icons (ONLY when they are placed next to the custom launchers box). They also can be hidden all at once or individually.
      10	The searchbox can have a fixed width or an automatic width to fit the menu width.
      11	The applications info box can be hidden or replaced by traditional tooltips. Its text can also be aligned to the left.
      12	The size of the Favorites/Categories/Applications icons can be customized.
      13	The amount of recent files can be customized.
      14	The **Recent Files** category can be hidden. This is for people who want the **Recent Files** category hidden without disabling recent files globally.
      15	The **All Applications** category can be removed from the menu.
      16	The **Favorites** can now be displayed as one more category. The **All Applications** category has to be hidden.
      17	The placement of the categories box and the applications box can be swapped.
      18	Scrollbars in the applications box can be hidden.
      19	The padding of certain menu elements can be customized to override the current theme stylesheets.
      20	Recently installed applications highlighting can be disabled.
      21	Recently used applications can be remembered and will be displayed on a category called **Recent Apps**. The applications will be sorted by execution time and the name and icon of the category can be customized.
      22	Categories can be selected on hover (system default) or by clicking on them.
      23	The default **Add to panel**, **Add to desktop** and **Uninstall** context menu items can be hidden.
      24	The menu editor can be directly opened from this applet context menu without the need to open it from the settings windows of this applet.
      25	The context menu for applications has 5 new items:
      26	**Run as root:** Executes application as root.
      27	**Edit .desktop file:** Open the application's .desktop file with a text editor.
      28	**Open .desktop file folder:** Open the folder where the application's .desktop file is stored.
      29	**Run from terminal:** Open a terminal and run application from there.
      30	**Run from terminal as root:** Same as above but the application is executed as root.
      31	Keyboard navigation
      32	Almost all keyboard shortcuts on this menu are the same as the original menu. There are just a couple of differences that I was forced to add to my menu to make some of its features to work.
      33	Note:
      34	[[Left Arrow]] and [[Right Arrow]] keys:
      35	Cycles through the favorites box, applications box and categories box if the focus is in one of these boxes.
      36	If the focus is on the custom launchers box, these keys will cycle through this box buttons.
      37	[[Tab]] key:
      38	If the favorites box, applications box or categories box are currently focused, the [[Tab]] key will switch the focus to the custom launchers box.
      39	If the focus is on the custom launchers box, the focus will go back to the categories box.
      40	If the custom launchers box isn't part of the menu, the [[Tab]] key alone or [[Ctrl]]/[[Shift]] + [[Tab]] key are pressed, it will cycle through the favorites box, applications box and categories box.
      41	[[Up Arrow]] and [[Down Arrow]] keys:
      42	If the favorites box, applications box or categories box are currently focused, these keys will cycle through the items in the currently highlighted box.
      43	[[Page Up]] and [[Page Down]] keys: Jumps to the first and last item of the currently selected box. This doesn't affect the custom launchers.
      44	[[Menu]] or [[Alt]] + [[Enter]] keys: Opens and closes the context menu (if any) of the currently highlighted item.
      45	[[Enter]] key: Executes the currently highlighted item.
      46	[[Escape]] key: It closes the main menu. If a context menu is open, it will close the context menu instead and a second tap of this key will close the main menu.
      47	[[Shift]] + [[Enter]]: Executes the application as root. This doesn't affect the custom launchers.
      48	[[Ctrl]] + [[Enter]]: Open a terminal and run application from there. This doesn't affect the custom launchers.
      49	[[Ctrl]] + [[Shift]] + [[Enter]]: Open a terminal and run application from there, but the application is executed as root. This doesn't affect the custom launchers.
      50	Applications left click extra actions
      51	When left clicking an application on the menu, certain key modifiers can be pressed to execute an application in a special way.
      52	[[Shift]] + **Left click**: Executes application as root.
      53	[[Ctrl]] + **Left click**: Open a terminal and run application from there.
      54	[[Ctrl]] + [[Shift]] + **Left click**: Open a terminal and run application from there, but the application is executed as root.
      55	About \Run from terminal\ options
      56	These options are meant for debugging purposes (to see the console output after opening/closing a program to detect possible errors, for example). Instead of opening a terminal to launch a program of which one might not know its command, one can do it directly from the menu and in just one step. Options to run from a terminal an application listed on the menu can be found on the applications context menu and can be hidden/shown from this applet settings window.
      57	By default, these options will use the system's default terminal emulator (**x-terminal-emulator** on Debian based distributions). Any other terminal emulator can be specified inside the settings window of this applet, as long as said emulator has support for the **-e** argument. I did my tests with **gnome-terminal**, **xterm** and **terminator**. Additional arguments could be passed to the terminal emulator, but it's not supported by me.
      58	Favorites handling
      59	If the favorites box is **displayed**, favorites can be added/removed from the context menu for applications and by dragging and dropping applications to/from the favorites box.
      60	**Note:** To remove a favorite, drag a favorite outside the favorites box into any part of the menu.
      61	If the favorites box is **hidden** and the favorites category is enabled, favorites can be added/removed from the context menu for applications and by dragging and dropping applications to the favorites category. Its simple, if a favorite is dragged into the favorites category, the favorite will be removed. If what you drag into the favorites category is a non bookmarked application, then that application will be added to the favorites.
      62	**Note:** The favorites category will update its content after changing to another category and going back to the favorites category.
      63	Troubleshooting/extra information
      64	Run from terminal.
      65	Debian based distributions:
      66	If the command **x-terminal-emulator** doesn't run the terminal emulator that one wants to be the default, run the following command to set a different default terminal emulator.
      67	Type in the number of the selection and hit enter.
      68	For other distributions:
      69	Just set the terminal executable of your choice on this applet settings window.
      70	There is a file inside this applet directory called **run_from_terminal.sh**. ***Do not remove, rename or edit this file***. Otherwise, all of the *Run from terminal* options will break.
      71	There is a folder named **icons** inside this applet directory. It contains several symbolic icons (most of them are from the Faenza icon theme) and each icon can be used directly by name (on a custom launcher, for example).
      72	The following two sections are available only in English.
      73	Do not install on any other version of Cinnamon.
      74	Compatibility
      75	Contributors
      76	Changelog
      77	Help for %s
      78	IMPORTANT!!!
      79	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      80	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      81	Applets/Desklets/Extensions (a.k.a. xlets) localization
      82	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      83	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      84	If this xlet has no locale available for your language, you could create it by following the following instructions.
      85	App name only
      86	Fuzzy (EXPERIMENTAL)
      87	Default
      88	Search type:
      90	See this xlet help file.
