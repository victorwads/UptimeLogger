//
//  LegendView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 12/04/23.
//

import SwiftUI

struct LegendView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: LogItemView.iconBootTime)
                        Text("Hora de Inicio do SO")
                    }.padding(2)
                    HStack {
                        Image(systemName: LogItemView.iconScriptStartTime)
                        Text("Hora de Inicio do Serviço")
                    }.padding(2)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: LogItemView.iconShutdownTime)
                        Text("Hora de Desligamento")
                    }.padding(2)
                    HStack {
                        Image(systemName: LogItemView.iconUpTime)
                        Text("Periodo de tempo ligado")
                    }.padding(2)
                }
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: LogItemView.iconNormalShutDown).foregroundColor(.green)
                        Text("Desligamento normal")
                    }.padding(2)
                    HStack {
                        Image(systemName: LogItemView.iconUnexpected).foregroundColor(.red)
                        Text("Desligamento Inesperado")
                    }.padding(2)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: LogItemView.iconEdited)
                        Text("Registro editado")
                    }.padding(2)
                }
                Spacer()
            }
        }.padding(.bottom)
    }
}

//static let iconUpTime = "bolt.badge.clock.fill"

struct LegendView_Previews: PreviewProvider {
    static var previews: some View {
        LegendView()
    }
}
