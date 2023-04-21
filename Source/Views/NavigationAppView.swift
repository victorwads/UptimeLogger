//
//  MainView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

struct NavigationAppView: View {
    let provider: LogsProvider
    let name = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    
    var body: some View {
        NavigationView {
                MenuView(
                    provider: provider,
                    name: name
                ).navigationTitle("Menu")
                .frame(minWidth: 250)
            }
        .navigationTitle(name)
    }
}

struct MenuView: View {
    
    private let logsTag = 1
    private let settingsTag = 2
    private let installTag = 3

    @State private var selectedScreen: Int? = 1

    let provider: LogsProvider
    let name: String

    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

    var body: some View {
        VStack() {
            Text(name)
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            
            Divider()
            List() {
                NavigationLink(destination: LogsScreen(provider: provider), tag: logsTag, selection: $selectedScreen) {
                    Label(Strings.mainLogs.value, systemImage: "list.bullet.rectangle")
                }
                NavigationLink(destination: SettingsScreen(provider: provider), tag: 2, selection: $selectedScreen) {
                    Label("Configurações", systemImage: "gearshape")
                }
                NavigationLink(destination: UpdateScreen(), tag: installTag, selection: $selectedScreen) {
                    Label("Atualizações", systemImage: "arrow.clockwise")
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
        NavigationAppView(provider: LogsProvider())
            .environment(\.locale, .portuguese)
        NavigationAppView(provider: LogsProvider())
            .environment(\.locale, .english)
    }
}