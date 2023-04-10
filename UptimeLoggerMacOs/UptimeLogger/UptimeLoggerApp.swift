//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

@main
struct UptimeLoggerApp: App {
    
    @State private var logs: [LogItemInfo]? = nil
    @State private var allowShutDown: Bool = false

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.shared.folder
    var provider = LogsProvider.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                logs: $logs,
                logsFolder: $logsFolder,
                allowState: $allowShutDown,
                toggleShutdownAction: toggleShutdown
            ).onAppear {
                checkPermission()
            }
        }.commands {
            Menus(
                reloadAction: loadLogs,
                changeFolderAction: {changeFolder()}
            )
        }
    }
    
    func checkPermission() {
        provider.folder = logsFolder
        if FileManager.default.isReadableFile(atPath: provider.folder) {
            loadLogs()
        } else {
            changeFolder(false)
        }
    }

    func changeFolder(_ change: Bool = true) {
        FilesProvider.shared.authorize(LogsProvider.shared.folder, change) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
        }
    }

    func toggleShutdown() {
        provider.setShutDownAllowed(allow: !allowShutDown)
        loadAllowShutDownState()
    }

    func loadAllowShutDownState() {
        allowShutDown = provider.getShutDownAllowed()
    }

    func loadLogs() {
        logs = nil
        loadAllowShutDownState()
        DispatchQueue.global().async {
            logs = provider.loadLogs()
        }
    }
}
