//
//  Menus.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//
import SwiftUI

struct Menus: Commands {
    
    @Binding var foldersHistory: [String]
    
    let reloadAction: () -> Void
    let changeFolderAction: (String?) -> Void
    let clearRecentsAction: () -> Void
    
    var body: some Commands {
        CommandMenu("Logs") {
            Button(action: reloadAction) { Text("Reload") }
            if foldersHistory.count < 2 {
                Button(action: {changeFolderAction(nil)}) { Text("Change logs folder") }
            } else {
                Menu("Change logs folder") {
                    Button(action: clearRecentsAction) { Text("Clean Recents") }
                    Divider()
                    ForEach(foldersHistory, id: \.self) { folder in
                        Button(action: {changeFolderAction(folder)}) { Text(folder) }
                    }
                    Divider()
                    Button(action: {changeFolderAction(nil)}) { Text("New") }
                }
            }
            Button(action: showLogs) { Text("Open Logs Folder") }
        }
    }
    
    func showLogs() {
        NSWorkspace.shared.open(URL(fileURLWithPath: LogsProvider.shared.folder))
    }

}
