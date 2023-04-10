//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

@main
struct UptimeLoggerApp: App {
    
    @State var logs: [LogItemInfo]? = nil
    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.shared.folder
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                logs: $logs,
                logsFolder: $logsFolder
            ).onAppear {
                LogsProvider.shared.folder = logsFolder
                loadLogs()
            }
        }.commands {
            Menus(
                reloadAction: loadLogs,
                setLogsPathAction: {
                    logsFolder = $0
                    LogsProvider.shared.folder = $0
                }
            )
        }
    }
    
    func loadLogs() {
        logs = nil
        DispatchQueue.global().async {
            logs = LogsProvider.shared.loadLogs()
        }
    }
}
