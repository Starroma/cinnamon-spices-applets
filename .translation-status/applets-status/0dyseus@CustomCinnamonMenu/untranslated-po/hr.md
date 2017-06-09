# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@CustomCinnamonMenu](../README.md) &#187; **Croatian (hr)**

       1	Keyboard navigation
       2	Almost all keyboard shortcuts on this menu are the same as the original menu. There are just a couple of differences that I was forced to add to my menu to make some of its features to work.
       3	Note:
       4	[[Left Arrow]] and [[Right Arrow]] keys:
       5	Cycles through the favorites box, applications box and categories box if the focus is in one of these boxes.
       6	If the focus is on the custom launchers box, these keys will cycle through this box buttons.
       7	[[Tab]] key:
       8	If the favorites box, applications box or categories box are currently focused, the [[Tab]] key will switch the focus to the custom launchers box.
       9	If the focus is on the custom launchers box, the focus will go back to the categories box.
      10	If the custom launchers box isn't part of the menu, the [[Tab]] key alone or [[Ctrl]]/[[Shift]] + [[Tab]] key are pressed, it will cycle through the favorites box, applications box and categories box.
      11	[[Up Arrow]] and [[Down Arrow]] keys:
      12	If the favorites box, applications box or categories box are currently focused, these keys will cycle through the items in the currently highlighted box.
      13	[[Page Up]] and [[Page Down]] keys: Jumps to the first and last item of the currently selected box. This doesn't affect the custom launchers.
      14	[[Menu]] or [[Alt]] + [[Enter]] keys: Opens and closes the context menu (if any) of the currently highlighted item.
      15	[[Enter]] key: Executes the currently highlighted item.
      16	[[Escape]] key: It closes the main menu. If a context menu is open, it will close the context menu instead and a second tap of this key will close the main menu.
      17	[[Shift]] + [[Enter]]: Executes the application as root. This doesn't affect the custom launchers.
      18	[[Ctrl]] + [[Enter]]: Open a terminal and run application from there. This doesn't affect the custom launchers.
      19	[[Ctrl]] + [[Shift]] + [[Enter]]: Open a terminal and run application from there, but the application is executed as root. This doesn't affect the custom launchers.
      20	Applications left click extra actions
      21	When left clicking an application on the menu, certain key modifiers can be pressed to execute an application in a special way.
      22	[[Shift]] + **Left click**: Executes application as root.
      23	[[Ctrl]] + **Left click**: Open a terminal and run application from there.
      24	[[Ctrl]] + [[Shift]] + **Left click**: Open a terminal and run application from there, but the application is executed as root.
      25	About \Run from terminal\ options
      26	These options are meant for debugging purposes (to see the console output after opening/closing a program to detect possible errors, for example). Instead of opening a terminal to launch a program of which one might not know its command, one can do it directly from the menu and in just one step. Options to run from a terminal an application listed on the menu can be found on the applications context menu and can be hidden/shown from this applet settings window.
      27	By default, these options will use the system's default terminal emulator (**x-terminal-emulator** on Debian based distributions). Any other terminal emulator can be specified inside the settings window of this applet, as long as said emulator has support for the **-e** argument. I did my tests with **gnome-terminal**, **xterm** and **terminator**. Additional arguments could be passed to the terminal emulator, but it's not supported by me.
      28	Favorites handling
      29	If the favorites box is **displayed**, favorites can be added/removed from the context menu for applications and by dragging and dropping applications to/from the favorites box.
      30	**Note:** To remove a favorite, drag a favorite outside the favorites box into any part of the menu.
      31	If the favorites box is **hidden** and the favorites category is enabled, favorites can be added/removed from the context menu for applications and by dragging and dropping applications to the favorites category. Its simple, if a favorite is dragged into the favorites category, the favorite will be removed. If what you drag into the favorites category is a non bookmarked application, then that application will be added to the favorites.
      32	**Note:** The favorites category will update its content after changing to another category and going back to the favorites category.
      33	Troubleshooting/extra information
      34	Run from terminal.
      35	Debian based distributions:
      36	If the command **x-terminal-emulator** doesn't run the terminal emulator that one wants to be the default, run the following command to set a different default terminal emulator.
      37	Type in the number of the selection and hit enter.
      38	For other distributions:
      39	Just set the terminal executable of your choice on this applet settings window.
      40	There is a file inside this applet directory called **run_from_terminal.sh**. ***Do not remove, rename or edit this file***. Otherwise, all of the *Run from terminal* options will break.
      41	There is a folder named **icons** inside this applet directory. It contains several symbolic icons (most of them are from the Faenza icon theme) and each icon can be used directly by name (on a custom launcher, for example).
      42	The following two sections are available only in English.
      43	language-name
      44	Contributors
      45	Changelog
      46	Choose language
      47	Help for %s
      48	IMPORTANT!!!
      49	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      50	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      51	Applets/Desklets/Extensions (a.k.a. xlets) localization
      52	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      53	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      54	If this xlet has no locale available for your language, you could create it by following the following instructions.
      55	See this xlet help file.
