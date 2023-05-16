//
//  String+Localized.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

enum Strings: String {
    case providerFilesOpenMessage = "provider.files.openmessage"
    
    case resultsSort = "results.sort"
    case resultsSearch = "result.search"
    case resultsContains = "result.contains"
    case resultsContainsNot = "result.contains.not"
    case optionsAll = "options.all"

    case cancel = "cancel"
    case reload = "reload"
    case items = "items"

    case navLogs = "nav.logs"
    case navSettings = "nav.settings"
    case navUpdate = "nav.update"
    case navCurrent = "nav.current"

    case logsFilters = "logs.filters"
    case logsFiltersPower = "logs.filters.power"
    case logsFiltersPowerOn = "logs.filters.power.on"
    case logsFiltersPowerOff = "logs.filters.power.off"
    case logsFiltersShutdown = "logs.filters.shutdown"
    case logsFiltersShutdownN = "logs.filters.shutdown.normal"
    case logsFiltersShutdownU = "logs.filters.shutdown.unexpected"
    case logsSortNew = "logs.sort.new"
    case logsSortOld = "logs.sort.old"
    case logsSortUpLong = "logs.sort.long"
    case logsSortUpShort = "logs.sort.short"
    case logsDetails = "logs.details.click"
    case logsNotFound = "logs.notfound"

    case iconsHelp = "icons.help"

    case logHelp = "log.help"
    case logSysVersion = "log.sysversion"
    case logBoottime = "log.boottime"
    case logUptime = "log.uptime"
    case logActiveTime = "log.active"
    case logSuspendedTime = "log.suspended"
    case logStartup = "log.startup"
    case logNormal = "log.normal"
    case logUnexpected = "log.unexpected"
    case logEdited = "log.edited"
    
    case detailsNotFound = "details.notfound"
    case detailsNotFoundTip = "details.notfound.tip"

    case authorizeTitle = "authorize.title"
    case authorizeMessage = "authorize.message"
    case authorizeConfirm = "authorize.confirm"

    case settingsMonitoringService = "settings.monitoring.title"
    case settingsMonitoring = "settings.monitoring.label"
    case settingsInterval = "settings.interval"
    case settingsIntervalTip = "settings.interval.tip"
    case settingsDeveloper = "settings.developers.title"
    case settingsFolderChange = "settings.folders.change"
    case settingsFolderSelect = "settings.folders.select"
    case settingsHistory = "settings.folders.history.title"
    case settingsClean = "settings.folders.clean"

    case updateCurrent = "update.current"
    case updateLast = "update.last"
    case updateFinishTitle = "update.finish.alert.title"
    case updateFinishMessage = "update.finish.alert.message"
    case updateNow = "update.finish.alert.now"
    case updateNo = "update.available.no"
    case updateAvailable = "update.available"

    case dateAt = "date.at"
    case dateToday = "date.today"
    case dateYesterday = "date.yesterday"
    case dateDays = "date.days"
    case dateHours = "date.hours"
    case dateMinutes = "date.minutes"
    case dateSeconds = "date.seconds"

    var key: LocalizedStringKey {
        get { LocalizedStringKey(self.rawValue)}
    }
}

extension String {
    static func localized(_ key: Strings) -> String {
        return NSLocalizedString(key.rawValue, comment: "")
    }
}

extension LocalizedStringKey {
    static func key(_ key: Strings) -> LocalizedStringKey {
        return key.key
    }
}
