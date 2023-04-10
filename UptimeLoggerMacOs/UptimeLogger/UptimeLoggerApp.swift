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
    @State private var showingAlert = false

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
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("No permission to access logs folder"),
                    message: Text("To allow access, click Open in the next dialog and select the Logs folder."),
                    primaryButton: .default(Text("OK"), action: {
                        changeFolder()
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: {
                        NSApplication.shared.terminate(self)
                    })
                )
            }
        }.commands {
            Menus(
                reloadAction: loadLogs,
                changeFolderAction: changeFolder
            )
        }
    }
    
    func checkPermission() {
        provider.folder = logsFolder
        if FileManager.default.isReadableFile(atPath: provider.folder) {
            loadLogs()
        } else {
            showingAlert = true
        }
    }

    func changeFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = URL(fileURLWithPath: LogsProvider.shared.folder)

        openPanel.begin { result in
            if result == .OK, let url = openPanel.url {
                provider.folder = url.relativePath+"/"
                logsFolder = url.relativePath+"/"
            }
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
