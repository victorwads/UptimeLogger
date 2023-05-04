//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import FirebaseCrashlytics
import Foundation
import AppKit

class LogsProviderFilesSystem: LogsProvider {    
    
    var folder: String
    let manager = FileManager.default

    init(folder: String = AppDelegate.defaultFolder) {
        _ = FilesProvider.shared.isAutorized(folder)
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
                        LogItemInfo(logPath, content: log)
                    )
                }
            }
            results = results.sorted(by: { $0.scriptStartTime > $1.scriptStartTime })
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
        return results
    }

    func loadCurrentLog() -> LogItemInfo {
        return loadLogWith(filename: nil)
    }

    func loadLogWith(filename: String?) -> LogItemInfo {
        let filename: String = filename ?? getCurrentFileName();
        
        let contents = getFileContents(folder + "/" + filename) ?? ""

        return LogItemInfo(filename, content: contents)
    }
    
    func getLogFileName(_ fileName: String) -> String {
        return folder + "/" + fileName.replacingOccurrences(of: ".txt", with: ".log")
    }
    
    func loadProccessLogFor(log: LogItemInfo) -> [ProcessLogInfo] {
        let contents = getFileContents(getLogFileName(log.fileName)) ?? ""
        return ProcessLogInfo.processFile(content: contents)
    }
    
    func removeLog(_ fileName: String) {
        do {
            try manager.removeItem(atPath: folder + "/" + fileName)
            if (manager.fileExists(atPath: getLogFileName(fileName))) {
                try manager.removeItem(atPath: getLogFileName(fileName))
            }
        } catch {
            print("error: \(error)")
        }
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
