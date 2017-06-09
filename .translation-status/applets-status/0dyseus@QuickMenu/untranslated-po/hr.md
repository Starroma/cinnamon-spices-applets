# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@QuickMenu](../README.md) &#187; **Croatian (hr)**

       1	Applet usage
       2	Menu items to .desktop files will be displayed with the icon and name declared inside the .desktop files themselves.
       3	The menu can be kept open while activating menu items by pressing [[Ctrl]] + **Left click** or with **Middle click**.
       4	How to set a different icon for each sub-menu
       5	Create a file at the same level as the folders that will be used to create the sub-menus.
       6	The file name can be customized, doesn't need to have an extension name and can be a hidden file (a dot file). By default is called **0_icons_for_sub_menus.json**.
       7	Whatever name is chosen for the file, it will be automatically ignored and will never be shown on the menu.
       8	The path to the icon has to be a full path. A path starting with **~/** can be used and will be expanded to the user's home folder.
       9	If any sub-folder has more folders that need to have custom icons, just create another **0_icons_for_sub_menus.json** file at the same level that those folders.
      10	The content of the file is a *JSON object* and has to look as follows:
      11	Folder name
      12	Icon name or icon path for Folder name
      13	Warning!!!
      14	JSON *language* is very strict. Just be sure to ONLY use double quotes. And the last key/value combination DOESN'T have to end with a comma (**Folder name #n** in the previous example).
      15	The following two sections are available only in English.
      16	language-name
      17	Contributors
      18	Changelog
      19	Choose language
      20	Help for %s
      21	IMPORTANT!!!
      22	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      23	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      24	Applets/Desklets/Extensions (a.k.a. xlets) localization
      25	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      26	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      27	If this xlet has no locale available for your language, you could create it by following the following instructions.
      28	See this xlet help file.
