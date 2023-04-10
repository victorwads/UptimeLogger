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
    
    var body: some Scene {
        WindowGroup {
            ContentView(logs: $logs)
                .onAppear(perform: loadLogs)
        }.commands {
            Menus(
                reloadAction: loadLogs
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
