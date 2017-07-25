# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@QuickMenu](../README.md) &#187; **Croatian (hr)**

       1	Description
       2	The function of this applet is very simple, create a menu based on the files/folders found inside a main folder (specified on this applet settings window). The files will be used to create menu items and the sub folders will be used to create sub-menus.
       3	I mainly created this applet to replicate the functionality of the XFCE plugin called **Directory Menu** and the KDE widget called **Quick access**.
       4	Warning
       5	This applet has to read every single file/folder inside a main folder to create its menu. So, do not try to use this applet to create a menu based on a folder that contains thousands of files!!! Your system may slow down, freeze or even crash!!!
       6	Features
       7	More than one instance of this applet can be installed at the same time.
       8	A hotkey can be assigned to open/close the menu.
       9	Menu items to .desktop files will be displayed with the icon and name declared inside the .desktop files themselves.
      10	The menu can be kept open while activating menu items by pressing [[Ctrl]] + **Left click** or with **Middle click**.
      11	This applet can create menu and sub-menu items even from symbolic links found inside the main folder.
      12	Settings window
      13	Image featuring different icons for each sub-menu and different icon sizes
      14	Applet usage
      15	How to set a different icon for each sub-menu
      16	Create a file at the same level as the folders that will be used to create the sub-menus.
      17	The file name can be customized, doesn't need to have an extension name and can be a hidden file (a dot file). By default is called **0_icons_for_sub_menus.json**.
      18	Whatever name is chosen for the file, it will be automatically ignored and will never be shown on the menu.
      19	The path to the icon has to be a full path. A path starting with **~/** can be used and will be expanded to the user's home folder.
      20	If any sub-folder has more folders that need to have custom icons, just create another **0_icons_for_sub_menus.json** file at the same level that those folders.
      21	The content of the file is a *JSON object* and has to look as follows:
      22	Folder name
      23	Icon name or icon path for Folder name
      24	Warning!!!
      25	JSON *language* is very strict. Just be sure to ONLY use double quotes. And the last key/value combination DOESN'T have to end with a comma (**Folder name #n** in the previous example).
      26	The following two sections are available only in English.
      27	Do not install on any other version of Cinnamon.
      28	Compatibility
      29	Contributors
      30	Changelog
      31	Help for %s
      32	IMPORTANT!!!
      33	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      34	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      35	Applets/Desklets/Extensions (a.k.a. xlets) localization
      36	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      37	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      38	If this xlet has no locale available for your language, you could create it by following the following instructions.
      39	See this xlet help file.
