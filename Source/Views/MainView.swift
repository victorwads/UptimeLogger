//
//  MainView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

struct MainView: View {
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
                NavigationLink(destination: LogsScreen(provider: provider), tag: 1, selection: $selectedScreen) {
                    Label("Registros de Logs", systemImage: "list.bullet.rectangle")
                }
            }

            Divider()
            List() {
                NavigationLink(destination: InstallationView(
                    currentFolder: .constant(""), onContinue: {}
                ), tag: 3, selection: $selectedScreen) {
                    Label("Manutenção de Serviço", systemImage: "wrench.fill")
                }
                NavigationLink(destination: SettingsScreen(provider: provider), tag: 2, selection: $selectedScreen) {
                    Label("Configurações", systemImage: "gearshape")
                }
            }
            .frame(height: 80)

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
        MainView(provider: LogsProvider.shared)
    }
}
