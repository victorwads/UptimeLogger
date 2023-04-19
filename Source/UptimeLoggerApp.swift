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
    @Environment(\.openURL) var openURL
    
    @AppStorage("logsFolder") var storedFolder: String = LogsProvider.defaultLogsFolder

    var body: some Scene {
        let provider = LogsProvider(folder: storedFolder)
        WindowGroup {
            NavigationAppView(
                provider: provider
            )
        }
        WindowGroup {
            LogDetailsScreen(
                provider: provider
            )
        }
        .handlesExternalEvents(matching: [AppScheme.details])
        WindowGroup {
            VStack {
                Text("Permission tutorial")
                    .font(.title)
                    .handlesExternalEvents(preferring: [AppScheme.permissionTutorial], allowing: ["*"])
            }
            .frame(minWidth: 200, maxWidth: 200, minHeight: 170, maxHeight: 170)
            .fixedSize()
        }
        .windowStyle(.hiddenTitleBar)
        .handlesExternalEvents(matching: [AppScheme.permissionTutorial])
    }
}
