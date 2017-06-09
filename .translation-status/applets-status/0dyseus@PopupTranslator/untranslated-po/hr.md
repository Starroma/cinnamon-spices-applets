# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@PopupTranslator](../README.md) &#187; **Croatian (hr)**

       1	Dependencies
       2	If one or more of these dependencies are missing in your system, you will not be able to use this applet.
       3	xsel command
       4	XSel is a command-line program for getting and setting the contents of the X selection.
       5	Debian and Archlinux based distributions:
       6	The package is called **xsel**.
       7	xdg-open command
       8	Open a URI in the user's preferred application that handles the respective URI or file type.
       9	This command is installed with the package called **xdg-utils**.
      10	Installed by default in modern versions of Linux Mint.
      11	Python 3
      12	It should come already installed in all Linux distributions.
      13	requests Python 3 module
      14	Requests allow you to send HTTP/1.1 requests. You can add headers, form data, multi-part files, and parameters with simple Python dictionaries, and access the response data in the same way. It's powered by httplib and urllib3, but it does all the hard work and crazy hacks for you.
      15	Debian based distributions:
      16	The package is called **python3-requests**.
      17	Archlinux based distributions:
      18	The package is called **python-requests**.
      19	After installing any of the missing dependencies, Cinnamon needs to be restarted
      20	I don't use any other type of Linux distribution (Gentoo based, Slackware based, etc.). If any of the previous packages/modules are named differently, please, let me know and I will specify them in this help file.
      21	Note:
      22	Usage
      23	There are 4 *translations mechanisms* (**Left click**, **Middle click**, **Hotkey #1** and **Hotkey #2**). Each translation mechanism can be configured with their own service providers, language pairs and hotkeys.
      24	**First translation mechanism (Left click):** Translates any selected text from any application on your system. A hotkey can be assigned to perform this task.
      25	**First translation mechanism ([[Ctrl]] + Left click):** Same as **Left click**, but it will bypass the translation history. A hotkey can be assigned to perform this task.
      26	**Second translation mechanism (Middle click):** Same as **Left click**.
      27	**Second translation mechanism ([[Ctrl]] + Middle click):** Same as [[Ctrl]] + **Left click**.
      28	**Third translation mechanism (Hotkey #1):** Two hotkeys can be configured to perform a translation and a forced translation.
      29	**Fourth translation mechanism (Hotkey #2):** Two hotkeys can be configured to perform a translation and a forced translation.
      30	All translations are stored into the translation history. If a string of text was already translated in the past, the popup will display that stored translated text without making use of the provider's translation service.
      31	About translation history
      32	I created the translation history mechanism mainly to avoid the abuse of the translation services.
      33	If the Google Translate service is \abused\, Google may block temporarily your IP. Or what is worse, they could change the translation mechanism making this applet useless and forcing me to update its code.
      34	If the Yandex Translate service is \abused\, you are \wasting\ your API keys quota and they will be blocked (temporarily or permanently).
      35	In the context menu of this applet is an item that can open the folder were the translation history file is stored. From there, the translation history file can be backed up or deleted.
      36	NEVER edit the translation history file manually!!!
      37	If the translation history file is deleted/renamed/moved, Cinnamon needs to be restarted.
      38	How to get Yandex translator API keys
      39	Visit one of the following links and register a Yandex account (or use one of the available social services).
      40	English:
      41	Russian:
      42	Once you successfully finish creating your Yandex account, you can visit the link provided several times to create several API keys. **DO NOT ABUSE!!!**
      43	Once you have several API keys, you can add them to Popup Translator's settings window (one API key per line).
      44	Important notes about Yandex API keys
      45	The API keys will be stored into a preference. Keep your API keys backed up in case you reset Popup Translator's preferences.
      46	**NEVER make your API keys public!!!** The whole purpose of going to the trouble of getting your own API keys is that the only one \consuming their limits\ is you and nobody else.
      47	With each Yandex translator API key you can translate **UP TO** 1.000.000 (1 million) characters per day **BUT NOT MORE** than 10.000.000 (10 millions) per month.
      48	The following two sections are available only in English.
      49	language-name
      50	Contributors
      51	Changelog
      52	Choose language
      53	Help for %s
      54	IMPORTANT!!!
      55	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      56	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      57	Applets/Desklets/Extensions (a.k.a. xlets) localization
      58	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      59	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      60	If this xlet has no locale available for your language, you could create it by following the following instructions.
      61	Unable to execute file/command '%s':
      62	See this xlet help file.
