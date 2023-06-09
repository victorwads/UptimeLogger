# App and Logger Changelog

* [3.0.0 - Planning](https://github.com/victorwads/UptimeLogger/issues/4)

- [2.5.0](https://github.com/victorwads/UptimeLogger/releases/download/2.5.0/UptimeLogger-2.5.0.dmg)
  - App
    - logs list:
      - change system kernel uptime for "active time" if available
      - change "options" to "filters"
      - improve filters layout
      - improve default showed info and format
    - legend view:
      - change system kernel uptime for "active time"
      - texts, colors, button to hide and show
    - fixes:
      - macOs 11 crash on loading settings
      - processes interval label at settings screen 
  - Unistaller
    - now remove app's preferences and caches
  - Installer / Servive
    - on update script, service continue activetime count

* [2.4.0](https://github.com/victorwads/UptimeLogger/releases/download/2.4.0/UptimeLogger-2.4.0.dmg)
  * FIRST APPLE APROVED VERSION - no more warnings
  * Service
    * log script aproximated active uptime counting in background every 0,2 second with custom logic
      activetime: number
  * Code
    * use xcodegen para gerar o projeto
    * Fix unit tests sign
    * Fix runing locally for comtributors without Apple Develper Account

- [2.3.1](https://github.com/victorwads/UptimeLogger/releases/download/2.3.1/UptimeLogger-2.3.1.dmg)
  - App
    - Minor fix for macs without baterry

* [2.3 - Current](https://github.com/victorwads/UptimeLogger/releases/download/2.3/UptimeLogger-2.3.dmg)
  * App
    * Logs Screen: new layout
    * Details Screen: improve layout
    * **New** Current Screen to see current log status
    * Screen to adress the folder access autorization 
    * logs permisioning
    * Code
      * Fix App Localization and add French
      * Swift UI Refactor
      * Add firebase for Analitycs and Crashlytics
      * Add Script to check localization
  * Monitoring Service
    * Minor improvements
    * Remove `init:` from log contract

- [2.2](https://github.com/victorwads/UptimeLogger/releases/download/2.2/UptimeLogger-2.2.dmg)
  - App
    - New Update Screen to download new updates
    - Uninstall remover app caches for all users

* [2.1](https://github.com/victorwads/UptimeLogger/releases/download/2.1/UptimeLogger-2.1.dmg)
  * App
    * **New Features**
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
    * **New Features**
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
  * Monitoring Service
    * New Features
      * Identifies unexpected shutdowns automatically using the "trap" command
      * Logs versioning v4
        * Added `sysversion:` String
        * Added `batery:` [0-100]%
        * Added `charging:` true/false
        * Added `logprocess:` true/false
        * Added `logprocessinterval:` seconds
        * Added .log file with list of running processes when activated


- [1.3](https://github.com/victorwads/UptimeLogger/releases/download/1.3/UptimeLogger-1.3.zip)
  - App
    - Improve Log Item UX
    - Fix file access permision

* [1.2](https://github.com/victorwads/UptimeLogger/releases/download/1.2/UptimeLogger-1.2.zip)
  * App
    * Add Service Install Help Flow
    * Improve Layout UX
  * Monitoring Service
    * Logs Versioning - started v2
        * Add `uptime:` seconds
        * Add `lastrecord:` date
    * Shutdown DateTime
