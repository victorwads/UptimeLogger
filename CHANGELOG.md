# App and Logger Changelog

- Future Releases
  - Choose with infos about the logs are showed on logs screen
  - Filter logs
  - open original text log files
  - archive logs for better analyses and performance

----

- [2.2 - Current](https://github.com/victorwads/UptimeLogger/releases/download/2.2/UptimeLogger-2.2.dmg)
  - App
    - New Update Screen to download new updates
    - Uninstall remover app caches for all users

* [2.1](https://github.com/victorwads/UptimeLogger/releases/download/2.1/UptimeLogger-2.1.dmg)
  * App
    * New Features
      * Logs List with more relevant information like, batery, connected power (or not) SO Version
      * Logs List with sorting, filtering by shutdown and charging status
      * Log Procces Details, with sorting, filtering, serach

- [2.0.1](https://github.com/victorwads/UptimeLogger/releases/download/2.0.1/UptimeLogger-2.0.1.dmg)
  - Fix for x86_64 macs
  - Fix installator update service system (keep current log)

* [2.0](https://github.com/victorwads/UptimeLogger/releases/download/2.0/UptimeLogger-2.0.dmg)
  * App
    * Fixes
      * Fixed file access issue
    * New Features
      * New logs details screen, in a separate window
      * Settings screen, with options for process monitoring with time interval, and developer options
      * Simple Install and Uninstaller on .DMG file for Download
      * You can now change logs final status and edited logs will be marked (you can also undo)
      * Improved ogs layout, and for next releases, it will be even better
    * Removed
      * System Menus Buttons
      * Install Service Screen
      * Now unecessary shutdown button from logs screen
    * Xcode Project
      * Added unit testing to prevent log misspelling bugs
  * Logger Service
    * New Features
      * Identifies unexpected shutdowns automatically using the "trap" command
      * Logs versioning v4
        * Added sysversion: String
        * Added batery: [0-100]%
        * Added charging: true/false
        * Added logprocess: true/false
        * Added logprocessinterval: seconds
        * Added .log file with list of running processes when activated


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
