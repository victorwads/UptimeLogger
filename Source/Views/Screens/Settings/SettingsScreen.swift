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
    
    let provider: LogsProvider
    
    var body: some View {
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
            
            Text("Opções de Desenvolvedor")
                .font(.headline)
            
            HStack {
                TextField("", text: .constant(provider.folder))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {}) {
                    Text(Strings.menuFoldersChange.value)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Configurações")
    }
}




struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen(provider: LogsProvider.shared)
    }
}
