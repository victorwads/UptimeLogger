//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

@main
struct UptimeLoggerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            Menus()
        }
    }
}

struct Menus: Commands {
    var body: some Commands {
        CommandMenu("Logs") {
            Button(action: {
                let openPanel = NSOpenPanel()
                openPanel.canChooseDirectories = true
                openPanel.canChooseFiles = false
                openPanel.allowsMultipleSelection = false
                openPanel.directoryURL = URL(fileURLWithPath: LogsProvider.folder)

                openPanel.begin { result in
                    if result == .OK, let url = openPanel.url {
                        LogsProvider.folder = url.relativePath+"/"
                    }
                }
            }) {
                Text("Change logs folder")
            }
            Button(action: {
                let logsFolderURL = URL(fileURLWithPath: LogsProvider.folder)
                NSWorkspace.shared.open(logsFolderURL)
            }) {
                Text("Open Logs Folder")
            }
        }
    }
}
