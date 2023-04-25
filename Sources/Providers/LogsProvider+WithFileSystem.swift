//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation
import AppKit
import FirebaseCrashlytics

class LogsProviderFilesSystem: LogsProvider {    
    
    static let defaultLogsFolder = "/Library/Application Support/UptimeLogger"
    
    var folder: String
    let manager = FileManager.default

    init(folder: String = LogsProviderFilesSystem.defaultLogsFolder) {
        self.folder = folder
    }
    
    var isReadable: Bool { manager.isReadableFile(atPath: folder) }
    var isWriteable: Bool { manager.isWritableFile(atPath: folder) }
    
    func setFolder(_ folder: String) {
        self.folder = folder
    }
    
    func loadLogs() -> [LogItemInfo] {
        var results: [LogItemInfo] = []
        
        let currentFileName = getCurrentFileName()
        do {
            let allFiles: [String] = try manager.contentsOfDirectory(atPath: folder)
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
            Crashlytics.crashlytics().record(error: error)
            return []
        }
    }

    func loadCurrentLog() -> LogItemInfo {
        return loadLogWith(filename: nil)
    }

    func loadLogWith(filename: String?) -> LogItemInfo {
        let filename: String = filename ?? getCurrentFileName();
        
        let contents = getFileContents(folder + "/" + filename) ?? ""

        return LogItemInfo(fileName: filename, content: contents)
    }
    
    func loadProccessLogFor(filename: String) -> [ProcessLogInfo] {
        let contents = getFileContents(folder + "/" + filename.replacingOccurrences(of: ".txt", with: ".log")) ?? ""
        return ProcessLogInfo.processFile(content: contents)
    }
    
    func toggleShutdownAllowed(_ file: LogItemInfo) {
        let allowed = !file.shutdownAllowed
        if let logData = manager.contents(atPath: folder+"/"+file.fileName),
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
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    
    
    
    
    
    private func getCurrentFileName() -> String {
        do {
            let symlinkPath = folder + "/latest"
            let realPath = try manager.destinationOfSymbolicLink(atPath: symlinkPath)
            let url = URL(fileURLWithPath: realPath)
            return url.lastPathComponent
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return ""
        }
    }
     
    private func getFileContents(_ filePath: String) -> String? {
        if let logData = manager.contents(atPath: filePath) {
            return String(data: logData, encoding: .utf8)
        }
        return ""
    }
}
