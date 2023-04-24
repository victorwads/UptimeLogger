//
//  SettingsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

struct SettingsScreen: View {
    
    @AppStorage("monitoringEnabled") private var monitoringEnabled = false
    @AppStorage("monitoringInterval") private var monitoringInterval = 1.0
    @AppStorage("logsFolder") var storedFolder: String = LogsProvider.defaultLogsFolder
    @AppStorage("foldersHistory") var storedFoldersHistory: String = LogsProvider.defaultLogsFolder
    @State private var foldersHistory: [String] = []

    let provider: LogsProvider
    
    var body: some View {
        HeaderView("Configurações", icon: "gearshape")
        VStack(alignment: .leading, spacing: 20) {
            Text("Serviço de Monitoramento")
                .font(.headline)
            
            HStack(alignment: .top) {
                Toggle(isOn: $monitoringEnabled) {
                    Text("Ativar monitoramento de processos")
                }
                
                Spacer()
                
                VStack {
                    Slider(
                        value: $monitoringInterval,
                        in: 1...15,
                        step: 1
                    ) { Text("Intervalo:").foregroundColor(monitoringEnabled ? .accentColor : .gray) }
                    minimumValueLabel: { Text("0") }
                    maximumValueLabel: { Text("15") }
                        .disabled(!monitoringEnabled)
                    
                    Text("salvar processos a cada \(Int(monitoringInterval)) segundos")
                        .foregroundColor(monitoringEnabled ? .accentColor : .gray)
                }.frame(maxWidth: 300)

            }
            
            Spacer()

            if _isDebugAssertConfiguration() {
                VStack(alignment: .leading) {
                    Divider()
                    Text("Opções de Desenvolvedor")
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            let domain = Bundle.main.bundleIdentifier!
                            UserDefaults.standard.removePersistentDomain(forName: domain)
                            NSApp.terminate(nil)
                        }) {
                            Text("Limpar todas preferencias")
                        }
                    }
                    
                    HStack {
                        TextField("", text: .constant(storedFolder))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: changeFolder) {
                            Text(Strings.menuFoldersChange.value)
                        }
                    }
                    
                    let history = foldersHistory.filter({ $0 != storedFolder})
                    
                    if(history.count > 0) {
                        HStack {
                            Text("Historico")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Button("Limpar Historico") {
                                storedFolder = LogsProvider.defaultLogsFolder
                                storedFoldersHistory = storedFolder
                                foldersHistory = [storedFolder]
                                provider.folder = storedFolder
                            }
                        }
                        ForEach(history, id: \.self) { folder in
                            HStack {
                                Text(folder).font(.callout).padding(.vertical, 2)
                                Spacer()
                                Button("Usar") { changeFolder(folder, change: false) }
                                    .buttonStyle(.link)
                            }
                        }
                    }
                }.padding(.bottom)
            }
        }
        .padding()
        .navigationTitle("Configurações")
        .onChange(of: monitoringEnabled, perform: {_ in saveConfigs()})
        .onChange(of: monitoringInterval, perform: {_ in saveConfigs()})
        .onAppear(perform: loadConfigs)
    }
    
    func saveConfigs(){
        if monitoringEnabled {
            _ = provider.saveSettings(Int(monitoringInterval))
        } else {
            _ =  provider.saveSettings(nil)
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
            provider.folder = $0
            storedFolder = $0
            updateRecents()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingsScreen(
                provider: LogsProvider()
            )
        }
    }
}
