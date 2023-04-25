//
//  LogsProvider+Settings.swift
//  UptimeLogger
//
//  Created by Victor Wads on 12/04/23.
//

import Foundation
import FirebaseCrashlytics

extension LogsProvider {
    
    private var configsFile: String { folder + "/config" }
    
    public func getSettings() -> Int? {
        if let logData = FileManager.default.contents(atPath: configsFile) {
            return Int(String(data: logData, encoding: .utf8) ?? "")
        }
        return nil
    }

    public func saveSettings(_ interval: Int?) -> Int? {
        do {
            if let int = interval {
                try String(int).write(toFile: configsFile, atomically: true, encoding: .utf8)
            } else {
                try FileManager.default.removeItem(atPath: configsFile)
            }
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }

        return getSettings()
    }

}
