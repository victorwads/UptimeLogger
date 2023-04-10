//
//  Menus.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//
import SwiftUI

struct Menus: Commands {
    
    let reloadAction: () -> Void
    let setLogsPathAction: (String) -> Void
    
    var body: some Commands {
        CommandMenu("Logs") {
            Button(action: reloadAction) { Text("Reload") }
            Button(action: changeFolder) { Text("Change logs folder") }
            Button(action: showLogs) { Text("Open Logs Folder") }
        }
    }
    
    func showLogs() {
        NSWorkspace.shared.open(URL(fileURLWithPath: LogsProvider.shared.folder))
    }
    
    func changeFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = URL(fileURLWithPath: LogsProvider.shared.folder)

        openPanel.begin { result in
            if result == .OK, let url = openPanel.url {
                setLogsPathAction(url.relativePath+"/")
            }
            reloadAction()
        }
    }
}
