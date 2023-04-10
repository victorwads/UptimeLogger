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
    @State private var currentLog: LogItemInfo = LogItemInfo()
    @State private var foldersHistory: [String] = []

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.shared.folder
    @AppStorage("foldersHistory") var logsFolderHistory: String = ""
    
    private var wrapper = TimerWrapper()
    private var provider = LogsProvider.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                logs: $logs,
                logsFolder: $logsFolder,
                current: $currentLog,
                toggleCurrentAction: {
                    provider.setShutDownAllowed(allow: !currentLog.shutdownAllowed)
                },
                toggleItemAction: {item in
                    provider.toggleShutdownAllowed(item)
                    loadLogs()
                }
            ).onAppear {
                provider.folder = logsFolder
                loadRecents()
                changeFolder(false)
            }
            .onAppear(perform: {
                wrapper.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    loadCurrent()
                }
                wrapper.timer?.fire()
            })
            .onDisappear(perform: {
                wrapper.timer?.invalidate()
                wrapper.timer = nil
            })
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
    
    private func loadRecents() {
        foldersHistory = logsFolderHistory.components(separatedBy: ",").filter { !$0.isEmpty }
    }

    private func updateRecents() {
        let path = provider.folder
        if !foldersHistory.contains(path) {
            foldersHistory.append(path)
            logsFolderHistory = foldersHistory.joined(separator: ",")
        }
    }
    
    private func changeFolder(_ change: Bool = true, _ folder: String? = nil) {
        let folder = folder ?? LogsProvider.shared.folder
        FilesProvider.shared.authorize(folder, change) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
            updateRecents()
        }
    }
    
    private func loadCurrent() {
        var current = provider.loadCurrentLog()
        current.shutdownAllowed = provider.getShutDownAllowed()
        currentLog = current
    }

    private func loadLogs() {
        logs = nil
        loadCurrent()
        DispatchQueue.global().async {
            logs = provider.loadLogs()
        }
    }
}

class TimerWrapper {
    var timer: Timer? = nil
}
