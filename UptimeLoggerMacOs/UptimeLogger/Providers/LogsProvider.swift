//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation
import AppKit

class LogsProvider {
    
    static let shared = LogsProvider()
    
    var folder = "/Library/UptimeLogger/logs/"
 
    public func loadLogs() -> [LogItemInfo] {
        var results: [LogItemInfo] = []
        let logFiles = FileManager.default.enumerator(atPath: folder)?.allObjects as? [String] ?? []
        let logFilePaths = logFiles.filter { $0.hasSuffix(".txt") }.map { $0 }
        
        for logFilePath in logFilePaths {
            if let logData = FileManager.default.contents(atPath: folder+logFilePath),
               let log = String(data: logData, encoding: .utf8) {
                results.append(
                    LogItemInfo(fileName: logFilePath, content: log)
                )
            }
        }
        results = results.sorted(by: { $0.startUpTime > $1.startUpTime })
        
        return results
    }
    
    public func setShutDownAllowed(allow: Bool) {
        let filePath = folder + "shutdown"
        if allow {
            FileManager.default.createFile(atPath: filePath, contents: "".data(using: .utf8), attributes: nil)
        } else {
            let url = URL.init(fileURLWithPath: filePath, isDirectory: true)
            do {
                try FileManager.default.trashItem(at: url, resultingItemURL: nil)
            } catch {
                print("Error removing shutdown file: \(error.localizedDescription)")
            }
        }
    }

    public func getShutDownAllowed() -> Bool {
        let filePath = folder + "shutdown"
        return FileManager.default.fileExists(atPath: filePath)
    }

}
