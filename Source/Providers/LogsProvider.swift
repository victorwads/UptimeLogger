//
//  LogsProvider.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import Foundation
import AppKit

class LogsProvider {
    
    private static let serviceFolder = "/Library/UptimeLogger/"
    private let scriptName = "uptime_logger.sh"

    static let shared = LogsProvider()
    var folder = serviceFolder + "logs"

    private func getFileContents(_ filePath: String) -> String? {
        if let logData = FileManager.default.contents(atPath: filePath) {
            return String(data: logData, encoding: .utf8)
        }
        return ""
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
        results = results.sorted(by: { $0.startUpTime > $1.startUpTime })
        
        return results
    }
    
    public func setShutDownAllowed(allow: Bool) {
        let filePath = folder + "/" + "shutdown"
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
        let filePath = folder + "/" + "shutdown"
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    public func toggleShutdownAllowed(_ file: LogItemInfo) {
        let allowed = !file.shutdownAllowed
        if let logData = FileManager.default.contents(atPath: folder+"/"+file.fileName),
           let log = String(data: logData, encoding: .utf8) {
            
            let key = "shutdown allowed"
            var lines = log.components(separatedBy: "\n")
            if allowed {
                lines.append(key)
            } else {
                lines = lines.filter { !$0.hasPrefix(key) }
            }
            do {
                try lines.joined(separator: "\n").write(toFile: folder+"/"+file.fileName, atomically: true, encoding: .utf8)
            } catch {
                
            }
        }
    }
    
    public var isServiceInstalled: Bool {
        get {
            FileManager.default.fileExists(atPath: LogsProvider.serviceFolder + scriptName)
        }
    }
    
    public func installService() {
        if let resourcePath = Bundle.main.resourcePath {
            let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = ["-a", "Terminal", "-n", resourcePath + "/Scripts/"]
            task.launch()
        }
    }

}
