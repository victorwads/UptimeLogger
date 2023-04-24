//
//  LegendView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 12/04/23.
//

import SwiftUI

struct LegendView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                Label("Hora de Inicio do SO", systemImage: LogItemView.iconBootTime)
                Label("Periodo de tempo ligado", systemImage: LogItemView.iconUpTime)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label("Hora de Inicio do Serviço", systemImage: LogItemView.iconScriptStartTime)
                Label("Desligamento normal", systemImage: LogItemView.iconNormalShutDown).foregroundColor(.green)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label("Registro editado", systemImage: LogItemView.iconEdited)
                Label("Desligamento Inesperado", systemImage: LogItemView.iconUnexpected).foregroundColor(.red)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label("Conectado a Energia", systemImage: LogItemView.iconPowerConnected)
                Label("Desconectado da Energia", systemImage: LogItemView.iconPowerDisconnected)
            }
        }.padding(.horizontal)
    }
}

//static let iconUpTime = "bolt.badge.clock.fill"

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        LegendView()
            .frame(minWidth: 1000, minHeight: 80)
    }
}
