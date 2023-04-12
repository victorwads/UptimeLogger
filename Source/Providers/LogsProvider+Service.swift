//
//  LogsProvider+Service.swift
//  UptimeLogger
//
//  Created by Victor Wads on 12/04/23.
//

import Foundation

extension LogsProvider {
    
    public var isServiceInstalled: Bool {
        get {
            FileManager.default.fileExists(atPath: LogsProvider.serviceFolder + LogsProvider.scriptName)
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
