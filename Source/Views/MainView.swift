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
            MenuView(provider: provider, name: name).navigationTitle("Menu")
        }
        .navigationTitle(name)
    }
}

struct MenuView: View {
    
    let provider: LogsProvider
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let name: String
    
    @State private var selectedScreen: Int? = nil

    var body: some View {
        VStack() {
            Text(name)
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            List() {
                NavigationLink(destination: LogsListScreen(provider: provider), tag: 1, selection: $selectedScreen) {
                    Label("Registros de Logs", systemImage: "list.bullet.rectangle")
                }.padding(.vertical, 5)
                NavigationLink(destination: SettingsScreen(), tag: 2, selection: $selectedScreen) {
                    Label("Configuração", systemImage: "gearshape")
                }.padding(.vertical, 5)
                NavigationLink(destination: InstallationView(
                    currentFolder: .constant(""), onContinue: {}
                ), tag: 3, selection: $selectedScreen) {
                    Label("Manutenção de Serviço", systemImage: "wrench.fill")
                }.padding(.vertical, 5)
            }
            .listStyle(.sidebar)
            .onAppear {
                selectedScreen = 1
            }
            
            Text(version)
                .foregroundColor(.gray)
                .font(.footnote)
                .padding(.bottom)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(provider: LogsProvider.shared)
    }
}
