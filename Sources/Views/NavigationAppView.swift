//
//  MainView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI
import FirebaseAnalytics

struct NavigationAppView: View {
    let provider: LogsProvider
    let name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    var body: some View {
        NavigationView {
            MenuView(
                provider: provider,
                name: name, version: version
            )
            .frame(minWidth: 250)
        }
        .navigationTitle(name)
    }
}

struct MenuView: View {
    
    static let iconLogs = "list.bullet.rectangle"
    static let iconCurrent = "hourglass.badge.plus"
    static let iconSettings = "gearshape"
    static let iconUpdate = "arrow.clockwise"

    private let logsTag = 1
    private let currentTag = 4
    private let settingsTag = 2
    private let installTag = 3

    @State private var selectedScreen: Int? = 1

    let provider: LogsProvider
    let name: String
    let version: String

    var body: some View {
        VStack() {
            Text(name)
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            
            Divider()
            List() {
                NavigationLink(destination: LogsScreen(provider: provider).onAppear {
                    Analytics.logEvent(
                        AnalyticsEventScreenView,
                        parameters: [
                            AnalyticsParameterScreenName: "Logs",
                            AnalyticsParameterScreenClass: "LogsScreen"
                        ]
                    )
                }, tag: logsTag, selection: $selectedScreen) {
                    Label(.key(.navLogs), systemImage: MenuView.iconLogs)
                }
                NavigationLink(destination: LogDetailsScreen(
                    provider: provider,
                    logFile: provider.loadCurrentLog()
                ).onAppear {
                    Analytics.logEvent(
                        AnalyticsEventScreenView,
                        parameters: [
                            AnalyticsParameterScreenName: "Currentlog",
                            AnalyticsParameterScreenClass: "LogDetailsScreen"
                        ]
                    )
                }, tag: currentTag, selection: $selectedScreen) {
                    Label(.key(.navCurrent), systemImage: MenuView.iconCurrent)
                }
                NavigationLink(destination: SettingsScreen(provider: provider).onAppear {
                    Analytics.logEvent(
                        AnalyticsEventScreenView,
                        parameters: [
                            AnalyticsParameterScreenName: "Settings",
                            AnalyticsParameterScreenClass: "SettingsScreen"
                        ]
                    )
                }, tag: 2, selection: $selectedScreen) {
                    Label(.key(.navSettings), systemImage: MenuView.iconSettings)
                }
                NavigationLink(destination: UpdateScreen().onAppear {
                    Analytics.logEvent(
                        AnalyticsEventScreenView,
                        parameters: [
                            AnalyticsParameterScreenName: "Find Update",
                            AnalyticsParameterScreenClass: "UpdateScreen"
                        ]
                    )
                }, tag: installTag, selection: $selectedScreen) {
                    Label(.key(.navUpdate), systemImage: MenuView.iconUpdate)
                }
            }

            Divider()
            Text(version)
                .foregroundColor(.gray)
                .font(.footnote)
                .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationAppView(provider: LogsProviderMock())
            .environment(\.locale, .portuguese)
        NavigationAppView(provider: LogsProviderMock())
            .environment(\.locale, .english)
    }
}
