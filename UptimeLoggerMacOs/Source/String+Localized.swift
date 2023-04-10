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
    case mainCurrentInfo = "main.current.info"
    case mainCurrentInform = "main.current.inform"
    case mainCurrentCancel = "main.current.inform.remove"
    case mainCurrentInformTip = "main.current.inform.tip"
    case mainCurrentCancelTip = "main.current.inform.remove.tip"

    case menuLogs = "menu.logs"
    case menuFoldersReload = "menu.folders.reload"
    case menuFoldersCleanRecents = "menu.folders.cleanrecents"
    case menuFoldersChange = "menu.folders.change"
    case menuFoldersNew = "menu.folders.new"
    case menuFoldersOpen = "menu.folders.open"

    case logsLoading = "logs.loading"
    case logsNotFound = "logs.notfound"
    
    case logHelp = "log.help"
    case logStartup = "log.startup"
    case logUptime = "log.uptime"
    case logUnexpected = "log.unexpected"
    case logUnexpectedYes = "log.unexpected.yes"
    case logUnexpectedNo = "log.unexpected.no"
    
    
    var value: String{
        get { NSLocalizedString(self.rawValue, comment: "") }
    }
}
