//
//  UptimeLoggerApp.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI
import FirebaseCore

@main
struct UptimeLoggerApp: App {

    static let isTest = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    static let analytics: AnalyticsProvider = isTest ? AnalyticsProviderMock() : AnalyticsProviderFirebase()

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.openURL) var openURL
    
    @AppStorage("logsFolder") var storedFolder: String = LogsProviderFilesSystem.defaultLogsFolder
    
    var isTest: Bool { UptimeLoggerApp.isTest }
    var analytics: AnalyticsProvider { UptimeLoggerApp.analytics }
    
    var body: some Scene {
        let provider: LogsProvider = isTest ? LogsProviderMock() : LogsProviderFilesSystem(folder: storedFolder)
        WindowGroup {
            if !isTest {
                let _ = FirebaseApp.configure()
            }   
            NavigationAppView(
                provider: provider
            ).onAppear {
                analytics.screen("Main Window", "UptimeLoggerApp")
            }
        }
        WindowGroup {
            LogDetailsScreen(provider: provider).onAppear {
                analytics.screen("Log Details", "LogDetailsScreen")
            }
        }
        .handlesExternalEvents(matching: [AppScheme.details])
    }
}
