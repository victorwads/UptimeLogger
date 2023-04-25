//
//  LogsProvider+WithMock.swift
//  UptimeLogger
//
//  Created by Victor Wads on 24/04/23.
//

import Foundation

class LogsProviderMock: LogsProvider {

    var isReadable = true
    var isWriteable = true
    var folder: String
    
    init() {
        self.folder = "/"
    }
    
    func setFolder(_ folder: String) {
    }
    
    func loadLogs() -> [LogItemInfo] {
        return [
            LogItemInfo.fullNormal,
            LogItemInfo.empty,
            LogItemInfo.fullUnexpected,
            LogItemInfo.empty,
            LogItemInfo.fullNormal,
            LogItemInfo.empty,
            LogItemInfo.fullUnexpected,
            LogItemInfo.empty,
            LogItemInfo.fullNormal,
            LogItemInfo.empty,
            LogItemInfo.fullUnexpected,
            LogItemInfo.empty
        ]
    }

    func loadCurrentLog() -> LogItemInfo {
        return LogItemInfo.fullUnexpected
    }

    func loadLogWith(filename: String?) -> LogItemInfo {
        return LogItemInfo.fullNormal
    }
    
    func loadProccessLogFor(filename: String) -> [ProcessLogInfo] {
        return [
            ProcessLogInfo.example,
            ProcessLogInfo.example,
            ProcessLogInfo.example,
            ProcessLogInfo.example,
            ProcessLogInfo.example,
            ProcessLogInfo.example
        ]
    }
    
    func toggleShutdownAllowed(_ file: LogItemInfo) {
    }

}
