//
//  Menus.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//
import SwiftUI

struct Menus: Commands {
    
    let reloadAction: () -> Void
    let changeFolderAction: () -> Void

    var body: some Commands {
        CommandMenu("Logs") {
            Button(action: reloadAction) { Text("Reload") }
            Button(action: changeFolderAction) { Text("Change logs folder") }
            Button(action: showLogs) { Text("Open Logs Folder") }
        }
    }
    
    func showLogs() {
        NSWorkspace.shared.open(URL(fileURLWithPath: LogsProvider.shared.folder))
    }

}
