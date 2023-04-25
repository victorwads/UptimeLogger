//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct UptimeLoggerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.openURL) var openURL
    
    @AppStorage("logsFolder") var storedFolder: String = LogsProviderFilesSystem.defaultLogsFolder
    
    var body: some Scene {
        let provider = LogsProviderFilesSystem(folder: storedFolder)
        WindowGroup {
            if let _ = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] {
            } else {
                let _ = FirebaseApp.configure()
                NavigationAppView(provider: provider).onAppear {
                    Analytics.logEvent(
                        AnalyticsEventScreenView,
                        parameters: [
                            AnalyticsParameterScreenName: "Main Window",
                            AnalyticsParameterScreenClass: "UptimeLoggerApp"
                        ]
                    )
                }
            }
        }
        WindowGroup {
            LogDetailsScreen(provider: provider).onAppear {
                Analytics.logEvent(
                    AnalyticsEventScreenView,
                    parameters: [
                        AnalyticsParameterScreenName: "Log Details",
                        AnalyticsParameterScreenClass: "LogDetailsScreen"
                    ]
                )
            }
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
