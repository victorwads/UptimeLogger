# App and Logger Changelog

* [2.0 - Current](https://github.com/victorwads/UptimeLogger/releases/download/1.4/UptimeLogger-2.0.zip)
  * App
    * Fix not saving file permision
    * Removed system menus
    * Logs Screen
      * Remove shutdown button
      * Mark logs as "edited" when thet are updated
      * Improve Logs Layout
    * Intall Screen
      * Removed
      * Create a DMG with Install and Uninstall packages
    * **-new-** Settings Screen
      * Toggle Process monitorim
      * Set seconds interval for process monitorim
      * developer options
    * Xcode Project
      * Unit Testing to prevent logs digesting bugs
  * Logger Service
    * Logs Versioning - started v4
        * Add sysversion: String
        * Add batery: \[0-100]%
        * Add charging: true/false
        * Add logprocess: true/false
        * Add logprocessinterval: seconds
        * Add .log file with list of running process when actived
    * Identifies unexpected shutdowns automatically using "trap" comand

- [1.3](https://github.com/victorwads/UptimeLogger/releases/download/1.3/UptimeLogger-1.3.zip)
  - App
    - Improve Log Item UX
    - Fix file access permision

* [1.2](https://github.com/victorwads/UptimeLogger/releases/download/1.2/UptimeLogger-1.2.zip)
  * App
    * Add Service Install Help Flow
    * Improve Layout UX
  * Logger Service
    * Logs Versioning - started v2
        * Add uptime: seconds
        * Add lastrecord: date
    * Shutdown DateTime
