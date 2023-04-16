//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation
import AppKit

class LogsProvider {
    
    static let serviceFolder = "\(Bundle.main.resourcePath ?? "")/Service/"
    static let defaultLogsFolder = serviceFolder + "logs"

    public var folder = defaultLogsFolder
    
    init(folder: String = defaultLogsFolder) {
        self.folder = folder
    }
    
    private func getCurrentFileName() -> String {
        do {
            let symlinkPath = folder + "/latest"
            let realPath = try FileManager.default.destinationOfSymbolicLink(atPath: symlinkPath)
            let url = URL(fileURLWithPath: realPath)
            return url.lastPathComponent
        } catch {
            return ""
        }
    }
     
    func getFileContents(_ filePath: String) -> String? {
        if let logData = FileManager.default.contents(atPath: filePath) {
            return String(data: logData, encoding: .utf8)
        }
        return ""
    }

    public func loadCurrentLog() -> LogItemInfo {
        let filename = getCurrentFileName()
        let contents = getFileContents(folder + "/" + filename) ?? ""

        return LogItemInfo(fileName: filename, content: contents)
    }
    
    public func loadLogs() -> [LogItemInfo] {
        var results: [LogItemInfo] = []
        
        let currentFileName = getCurrentFileName()
        
        let logFiles = FileManager.default.enumerator(atPath: folder)?.allObjects as? [String] ?? []
        let logFilePaths = logFiles.filter { $0.hasSuffix(".txt") && $0 != currentFileName }
        
        for logFilePath in logFilePaths {
            if let log = getFileContents(folder+"/"+logFilePath) {
                results.append(
                    LogItemInfo(fileName: logFilePath, content: log)
                )
            }
        }
        results = results.sorted(by: { $0.scriptStartTime > $1.scriptStartTime })
        
        return results
    }

    public func toggleShutdownAllowed(_ file: LogItemInfo) {
        let allowed = !file.shutdownAllowed
        if let logData = FileManager.default.contents(atPath: folder+"/"+file.fileName),
           let log = String(data: logData, encoding: .utf8) {
            
            var lines = log.components(separatedBy: "\n").filter { !$0.hasPrefix(LogItemInfo.edited) }
            if allowed {
                lines.append(LogItemInfo.edited + LogItemInfo.shutdownAllowed)
            } else {
                lines.append(LogItemInfo.edited + LogItemInfo.shutdownUnexpected)
            }
            do {
                try lines.joined(separator: "\n").write(toFile: folder+"/"+file.fileName, atomically: true, encoding: .utf8)
            } catch {
                
            }
        }
    }
}
