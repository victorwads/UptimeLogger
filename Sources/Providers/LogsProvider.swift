//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

protocol LogsProvider {
    
    var folder: String { get }
    var isReadable: Bool { get }
    var isWriteable: Bool { get }

    func setFolder(_ folder: String)

    func loadLogs() -> [LogItemInfo]

    func loadCurrentLog() -> LogItemInfo

    func loadLogWith(filename: String?) -> LogItemInfo
    
    func loadProccessLogFor(filename: String) -> [ProcessLogInfo]

    func toggleShutdownAllowed(_ log: LogItemInfo)
}
