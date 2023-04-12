//
//  LogsProvider+Settings.swift
//  UptimeLogger
//
//  Created by Victor Wads on 12/04/23.
//

import Foundation

extension LogsProvider {
    
    private static let configsName = "config"
    private var configsFile: String { folder + "/" + LogsProvider.configsName }
    
    public func getSettings() -> Int? {
        return Int(
            getFileContents(configsFile) ?? ""
        )
    }

    public func saveSettings(_ interval: Int?) -> Int? {
        
        do {
            if let int = interval {
                try String(int).write(toFile: configsFile, atomically: true, encoding: .utf8)
            } else {
                try FileManager.default.removeItem(atPath: configsFile)
            }
        } catch {}

        return getSettings()
    }

}
