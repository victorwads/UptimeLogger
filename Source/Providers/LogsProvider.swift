//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation
import AppKit

class LogsProvider {
    
    static let defaultLogsFolder = "/Library/Application Support/UptimeLogger"

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

    public func loadLogWith(filename: String? = nil) -> LogItemInfo {
        let filename: String = filename ?? getCurrentFileName();
        
        let contents = getFileContents(folder + "/" + filename) ?? ""

        return LogItemInfo(fileName: filename, content: contents)
    }
    
    public func loadProccessLogFor(filename: String) -> [String] {
        let contents = getFileContents(folder + "/" + filename.replacingOccurrences(of: ".txt", with: ".log")) ?? ""
        return contents.components(separatedBy: "\n")
    }
    
    public func loadLogs() -> [LogItemInfo] {
        var results: [LogItemInfo] = []
        
        let currentFileName = getCurrentFileName()
        do {
            let allFiles: [String] = try FileManager.default.contentsOfDirectory(atPath: folder)
            let logFiles = allFiles.filter { $0.hasPrefix("log_") && $0.hasSuffix(".txt") && $0 != currentFileName }
            
            for logPath in logFiles {
                if let log = getFileContents(folder+"/"+logPath) {
                    results.append(
                        LogItemInfo(fileName: logPath, content: log)
                    )
                }
            }
            results = results.sorted(by: { $0.scriptStartTime > $1.scriptStartTime })
            
            return results
        } catch {
            return []
        }
    }

    public func toggleShutdownAllowed(_ file: LogItemInfo) {
        let allowed = !file.shutdownAllowed
        if let logData = FileManager.default.contents(atPath: folder+"/"+file.fileName),
           let log = String(data: logData, encoding: .utf8) {
            
            var lines = log.components(separatedBy: "\n").filter { !$0.hasPrefix(LogItemInfo.editedLog) }
            if allowed {
                lines.append(LogItemInfo.editedLog + LogItemInfo.shutdownAllowed)
            } else {
                lines.append(LogItemInfo.editedLog + LogItemInfo.shutdownUnexpected)
            }
            do {
                try lines.joined(separator: "\n").write(toFile: folder+"/"+file.fileName, atomically: true, encoding: .utf8)
            } catch {
                
            }
        }
    }
}
