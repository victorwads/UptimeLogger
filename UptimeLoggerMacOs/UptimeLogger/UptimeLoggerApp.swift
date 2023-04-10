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
    @State private var foldersHistory: [String] = []

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.shared.folder
    @AppStorage("foldersHistory") var logsFolderHistory: String = ""
    
    var provider = LogsProvider.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                logs: $logs,
                logsFolder: $logsFolder,
                allowState: $allowShutDown,
                toggleShutdownAction: toggleShutdown,
                toggleItemAction: {item in
                    provider.toggleShutdownAllowed(item)
                    loadLogs()
                }
            ).onAppear {
                provider.folder = logsFolder
                loadRecents()
                changeFolder(false)
            }
        }.commands {
            Menus(
                foldersHistory: $foldersHistory,
                reloadAction: loadLogs,
                changeFolderAction: { folder in changeFolder(folder==nil, folder)},
                clearRecentsAction: {
                    foldersHistory = []
                    logsFolderHistory = ""
                }
            )
        }
    }
    
    func loadRecents() {
        foldersHistory = logsFolderHistory.components(separatedBy: ",").filter { !$0.isEmpty }
    }

    func updateRecents() {
        let path = provider.folder
        if !foldersHistory.contains(path) {
            foldersHistory.append(path)
            logsFolderHistory = foldersHistory.joined(separator: ",")
        }
    }
    
    func changeFolder(_ change: Bool = true, _ folder: String? = nil) {
        let folder = folder ?? LogsProvider.shared.folder
        FilesProvider.shared.authorize(folder, change) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
            updateRecents()
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
