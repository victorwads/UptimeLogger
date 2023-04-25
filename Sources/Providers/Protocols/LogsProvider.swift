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

extension LogsProvider {
    func ifCanWrite(callback: @escaping () -> Void){
        FilesProvider.shared.authorizeIf(isWriteable, folder, callback: callback)
    }
    
    func ifCanRead(finish: Bool = false, callback: @escaping () -> Void){
        FilesProvider.shared.authorizeIf(isReadable, folder, finish: finish, callback: callback)
    }
}
