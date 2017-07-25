# Untranslated Items
[Applets](../../../README.md) &#187; [0dyseus@SysmonitorByOrcus](../README.md) &#187; **Croatian (hr)**

       1	Description
       2	This applet is a fork of [System Monitor](https://cinnamon-spices.linuxmint.com/applets/view/88) applet by Josef Michálek (a.k.a. Orcus).
       3	Differences with the original applet
       4	This applet uses Cinnamon's native settings system instead of an external library (gjs).
       5	I added an option to use a custom command on applet click.
       6	I added an option to set a custom width for each graph individually.
       7	I added an option to align this applet tooltip text to the left.
       8	Removed NetworkManager dependency.
       9	Dependencies
      10	The gtop library reads information about processes and the state of the system.
      11	Debian based distributions:
      12	The package is called **gir1.2-gtop-2.0**.
      13	Archlinux based distributions:
      14	The package is called **libgtop**.
      15	Fedora based distributions:
      16	The package is called **libgtop2-devel**.
      17	NetworkManager is a system network service that manages your network devices and connections, attempting to keep active network connectivity when available.
      18	The package is called **gir1.2-networkmanager-1.0**.
      19	The package is called **networkmanager**.
      20	The package is called **NetworkManager**.
      21	Important note:
      22	NetworkManager is only used if the **GTop** library version installed on a system is < **2.32** and doesn't support certain library calls. So, basically, if the network graph on this applet works without having installed NetworkManager, then you don't need to install it.
      23	Restart Cinnamon after installing the packages for the applet to recognize them.
      24	The following two sections are available only in English.
      25	Do not install on any other version of Cinnamon.
      26	Compatibility
      27	Contributors
      28	Changelog
      29	Help for %s
      30	IMPORTANT!!!
      31	Never delete any of the files found inside this xlet folder. It might break this xlet functionality.
      32	Bug reports, feature requests and contributions should be done on this xlet's repository linked next.
      33	Applets/Desklets/Extensions (a.k.a. xlets) localization
      34	If this xlet was installed from Cinnamon Settings, all of this xlet's localizations were automatically installed.
      35	If this xlet was installed manually and not trough Cinnamon Settings, localizations can be installed by executing the script called **localizations.sh** from a terminal opened inside the xlet's folder.
      36	If this xlet has no locale available for your language, you could create it by following the following instructions.
      37	See this xlet help file.
