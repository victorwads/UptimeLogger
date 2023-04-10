//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation

class LogsProvider {
    
    static var shared = LogsProvider()
    static var folder = "/Library/UptimeLogger/logs/"
 
    public func loadLogs() -> [LogItemInfo] {
        var results: [LogItemInfo] = []
        let logFiles = FileManager.default.enumerator(atPath: LogsProvider.folder)?.allObjects as? [String] ?? []
        let logFilePaths = logFiles.filter { $0.hasSuffix(".txt") }.map { $0 }
        
        for logFilePath in logFilePaths {
            if let logData = FileManager.default.contents(atPath: LogsProvider.folder+logFilePath),
               let log = String(data: logData, encoding: .utf8) {
                results.append(
                    LogItemInfo(fileName: logFilePath, content: log)
                )
            }
        }
        results = results.sorted(by: { $0.startUpTime > $1.startUpTime })
        
        return results
    }
    
}
