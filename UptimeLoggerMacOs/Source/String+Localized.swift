//
//  String+Localized.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import Foundation

enum Strings: String {
    case providerFilesOpenMessage = "provider.files.openmessage"
    case mainLogs = "main.logs"
    case mainCurrent = "main.current"
    case mainCurrentAllow = "main.current.allow"
    case mainCurrentDeny = "main.current.deny"
    case menuLogs = "menu.logs"
    case menuFoldersReload = "menu.folders.reload"
    case menuFoldersCleanRecents = "menu.folders.cleanrecents"
    case menuFoldersChange = "menu.folders.change"
    case menuFoldersNew = "menu.folders.new"
    case menuFoldersOpen = "menu.folders.open"
    case logsLoading = "logs.loading"
    case logsNotFound = "logs.notfound"
    case logAllow = "log.allow"
    case logDeny = "log.deny"
    case logStartup = "log.startup"
    case logUptime = "log.uptime"
    case logAllowed = "log.allowed"
    case logAllowedYes = "log.allowed.yes"
    case logAllowedNo = "log.allowed.no"
    
    var value: String{
        get { NSLocalizedString(self.rawValue, comment: "") }
    }
}
