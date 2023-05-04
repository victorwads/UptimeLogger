//
//  LogsProvider+WithMock.swift
//  UptimeLogger
//
//  Created by Victor Wads on 24/04/23.
//

import Foundation

class LogsProviderMock: LogsProvider {
    
    static let empty = LogItemInfo("", content: "")
    static let fullUnexpected = LogItemInfo("log_2023-04-17_00-13-40.txt", content: LogsProviderMock.fullLogContent + "logprocess: true")
    static let fullNormal = LogItemInfo("log_2023-05-17_00-11-40.txt", content: LogsProviderMock.fullLogContent + LogItemInfo.shutdownAllowed)
    static let fullLogContent = """
    version: 4
    ended: 2023-04-17_00-13-43
    sysversion: 13.4
    batery: 72%
    charging: false
    boottime: 1681697439
    activetime: 3600
    uptime: 3784
    logprocessinterval: 1

    """


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
            LogsProviderMock.fullNormal,
            LogsProviderMock.empty,
            LogsProviderMock.fullUnexpected,
            LogsProviderMock.empty,
            LogsProviderMock.fullNormal,
            LogsProviderMock.empty,
            LogsProviderMock.fullUnexpected,
            LogsProviderMock.empty,
            LogsProviderMock.fullNormal,
            LogsProviderMock.empty,
            LogsProviderMock.fullUnexpected,
            LogsProviderMock.empty
        ]
    }

    func loadCurrentLog() -> LogItemInfo {
        return LogsProviderMock.fullUnexpected
    }

    func loadLogWith(filename: String?) -> LogItemInfo {
        return LogsProviderMock.fullNormal
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
