//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

@main
struct UptimeLoggerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("logsFolder") var storedFolder: String = LogsProvider.defaultLogsFolder

    var body: some Scene {
        WindowGroup {
            MainView(
                provider: LogsProvider(folder: storedFolder)
            )
        }.commands {
//            Menus(
//                reloadAction: {loadLogs},
//            )
        }
    }
}
