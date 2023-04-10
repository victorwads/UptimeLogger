//
//  Menus.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//
import SwiftUI

struct Menus: Commands {
    
    @Binding var serviceInstalled: Bool
    @Binding var foldersHistory: [String]
    
    let reloadAction: () -> Void
    let changeFolderAction: (String?) -> Void
    let clearRecentsAction: () -> Void
    let installAction: () -> Void

    var body: some Commands {
        CommandMenu(Strings.menuLogs.value) {
            Button(action: reloadAction) {
                Text(Strings.menuFoldersReload.value)
            }
            if foldersHistory.count < 2 {
                Button(action: {changeFolderAction(nil)}) {
                    Text(Strings.menuFoldersChange.value)
                }
            } else {
                Menu(Strings.menuFoldersChange.value) {
                    Button(action: clearRecentsAction) {
                        Text(Strings.menuFoldersCleanRecents.value)
                    }
                    Divider()
                    ForEach(foldersHistory, id: \.self) { folder in
                        Button(action: {changeFolderAction(folder)}) { Text(folder) }
                    }
                    Divider()
                    Button(action: {changeFolderAction(nil)}) {
                        Text(Strings.menuFoldersNew.value)
                    }
                }
            }
            Button(action: showLogs) { Text(Strings.menuFoldersOpen.value) }
            if(!serviceInstalled){
                Divider()
                Button(action: installAction) {
                    Text("Install Service")
                }
            }
        }
    }
    
    func showLogs() {
        NSWorkspace.shared.open(URL(fileURLWithPath: LogsProvider.shared.folder))
    }

}
