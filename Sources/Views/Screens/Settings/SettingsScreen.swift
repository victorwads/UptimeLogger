//
//  SettingsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("logsFolder") var storedFolder: String = LogsProviderFilesSystem.defaultLogsFolder
    @AppStorage("foldersHistory") var storedFoldersHistory: String = LogsProviderFilesSystem.defaultLogsFolder

    @AppStorage("monitoringEnabled") private var monitoringEnabled = false
    @AppStorage("monitoringInterval") private var monitoringInterval = 1.0

    @State private var foldersHistory: [String] = []
    @State var saveConfigsOnlyAfterLoad: (() -> Void)? = nil

    let provider: LogsProvider

    var interval: String {
        "\(String.localized(.settingsIntervalTip)) \(Int(monitoringInterval)) \(String.localized(.dateSeconds))"
    }
    
    var body: some View {
        HeaderView(.key(.navSettings), icon: MenuView.iconSettings)
        VStack(alignment: .leading, spacing: 20) {
            Text(.key(.settingsMonitoringService))
                .font(.headline)
            
            HStack(alignment: .top) {
                Toggle(isOn: $monitoringEnabled) {
                    Text(.key(.settingsMonitoring))
                }
                
                Spacer()
                
                VStack {
                    Slider(
                        value: $monitoringInterval,
                        in: 1...15,
                        step: 1
                    ) { Text(.key(.settingsInterval)).foregroundColor(monitoringEnabled ? .accentColor : .gray) }
                    minimumValueLabel: { Text("0") }
                    maximumValueLabel: { Text("15") }
                        .disabled(!monitoringEnabled)
                    
                    Text(interval).foregroundColor(monitoringEnabled ? .accentColor : .gray)
                }.frame(maxWidth: 300)

            }
            
            Spacer()

            if _isDebugAssertConfiguration() {
                VStack(alignment: .leading) {
                    Divider()
                    Text(.key(.settingsDeveloper))
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            let domain = Bundle.main.bundleIdentifier!
                            UserDefaults.standard.removePersistentDomain(forName: domain)
                            NSApp.terminate(nil)
                        }) {
                            Text(.key(.settingsClean))
                        }
                    }
                    
                    HStack {
                        TextField("", text: .constant(storedFolder))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: changeFolder) {
                            Text(.key(.settingsFolderChange))
                        }
                    }
                    
                    let history = foldersHistory.filter({ $0 != storedFolder})
                    
                    if(history.count > 0) {
                        HStack {
                            Text(.key(.settingsHistory))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Button(.key(.settingsClean), action: cleanHistory)
                        }
                        ForEach(history, id: \.self) { folder in
                            HStack {
                                Text(folder).font(.callout).padding(.vertical, 2)
                                Spacer()
                                Button(.key(.settingsFolderSelect)) {
                                    changeFolder(folder, change: false)
                                    
                                }
                                .buttonStyle(.link)
                            }
                        }
                    }
                }.padding(.bottom)
            }
        }
        .padding()
        .navigationTitle(.key(.navSettings))
        .onAppear(perform: loadConfigs)
        .onChange(of: monitoringEnabled, perform: {_ in saveConfigsOnlyAfterLoad?()})
        .onChange(of: monitoringInterval, perform: {_ in saveConfigsOnlyAfterLoad?()})
    }
    
    func saveConfigs(){
        provider.ifCanWrite {
            if monitoringEnabled {
                _ = provider.saveSettings(Int(monitoringInterval))
            } else {
                _ =  provider.saveSettings(nil)
            }
        }
    }
    
    func loadConfigs(){
        let configs = provider.getSettings()
        if let interval = configs {
            monitoringEnabled = true
            monitoringInterval = Double(interval)
        } else {
            monitoringEnabled = false
        }
        foldersHistory = storedFoldersHistory.components(separatedBy: ",").filter { !$0.isEmpty }
        saveConfigsOnlyAfterLoad = saveConfigs
    }
    
    private func updateRecents() {
        let path = provider.folder
        if !foldersHistory.contains(path) {
            foldersHistory.append(path)
        }
        storedFoldersHistory = foldersHistory.joined(separator: ",")
    }

    private func changeFolder() {
        changeFolder(provider.folder)
    }
    
    private func changeFolder(_ folder: String, change: Bool = true) {
        FilesProvider.shared.authorize(folder, change) {
            provider.setFolder($0)
            storedFolder = $0
            updateRecents()
        }
    }
    
    private func cleanHistory() {
        storedFolder = LogsProviderFilesSystem.defaultLogsFolder
        foldersHistory = []
        provider.setFolder(storedFolder)
        updateRecents()
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingsScreen(
                provider: LogsProviderMock()
            )
        }
    }
}
