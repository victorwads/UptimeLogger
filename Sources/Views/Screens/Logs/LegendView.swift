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
                Label(.key(.logBoottime), systemImage: LogItemView.iconBootTime)
                Label(.key(.logUptime), systemImage: LogItemView.iconUpTime)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label(.key(.logStartup), systemImage: LogItemView.iconScriptStartTime)
                Label(.key(.logNormal), systemImage: LogItemView.iconNormalShutDown).foregroundColor(.green)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label(.key(.logEdited), systemImage: LogItemView.iconEdited)
                Label(.key(.logUnexpected), systemImage: LogItemView.iconUnexpected).foregroundColor(.red)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Label(.key(.logsOptionsPowerOn), systemImage: LogItemView.iconPowerConnected)
                Label(.key(.logsOptionsPowerOff), systemImage: LogItemView.iconPowerDisconnected)
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
