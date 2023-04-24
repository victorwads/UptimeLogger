//
//  LogItemView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogItemView: View {
    static let iconNormalShutDown = "checkmark.seal.fill"
    static let iconUnexpected = "bolt.trianglebadge.exclamationmark.fill"
    static let iconScriptStartTime = "gearshape.arrow.triangle.2.circlepath"
    static let iconShutdownTime = "powersleep"
    static let iconBootTime = "power"
    static let iconUpTime = "bolt.badge.clock.fill"
    static let iconEdited = "square.and.pencil"
    static let iconPowerConnected = "bolt.fill"
    static let iconPowerDisconnected = "bolt.slash.fill"
    static let iconSysVersion = "desktopcomputer"

    @Environment(\.openURL) var openURL
    
    @Binding var log: LogItemInfo
    var showDetails: Bool = false
    var onToggleAction: ((LogItemInfo) -> Void)? = nil

    private var allow: Bool {
        get { log.shutdownAllowed }
    }
    
    var initScriptView: some View {
        HStack(alignment: .center) {
            Image(systemName: LogItemView.iconScriptStartTime)
                .foregroundColor(.accentColor)
            MonoText(log.formattedStartUptime)
        }
    }

    var bootTimeView: some View  {
        HStack(alignment: .center) {
            Image(systemName: LogItemView.iconBootTime)
                .foregroundColor(.accentColor)
            MonoText(log.formattedBoottime ?? "null")
        }
    }
    
    var upTimeView: some View  {
        HStack(alignment: .center) {
            Image(systemName: LogItemView.iconUpTime)
                .foregroundColor(.accentColor)
            MonoText(log.formattedUptime)
        }
    }
    
    var shutdownStatus: some View {
        HStack(alignment: .center, spacing: 4) {
            let info = (!allow ? Strings.logUnexpectedYes.value : Strings.logUnexpectedNo.value)
            Text(info)
                .foregroundColor(allow ? .green : .red)
            Text(log.formattedEndtime)
                .foregroundColor(allow ? .green : .red)
            Image(systemName: allow ? LogItemView.iconNormalShutDown : LogItemView.iconUnexpected)
                .font(.headline)
                .foregroundColor(allow ? .green : .red)
        }
    }
    
    var energyStatus: some View {
        HStack {
            if let battery = log.batery, let charging = log.charging {
                Battery(level: battery)
                Image(systemName: charging ? LogItemView.iconPowerConnected : LogItemView.iconPowerDisconnected)
                    .help(charging ? "conectado a energia" : "desconectado da energia")
            }
        }
    }

    var sysVersionView: some View {
        HStack {
            if let sys = log.systemVersion {
                HStack {
                    Image(systemName: LogItemView.iconSysVersion)
                        .foregroundColor(.accentColor)
                    MonoText(sys)
                }.help("versão do SO")
            }
        }
    }

    var versionView: some View {
        Text("v\(log.version)")
            .foregroundColor(.gray)
    }

    var editedView: some View {
        Image(systemName: LogItemView.iconEdited)
            .help(Strings.logEditedTip.value)
    }

    var body: some View {
        HStack(alignment: .center) {
            if(!showDetails) {
                initScriptView.padding(.bottom, 2)
            }
            bootTimeView
            upTimeView
            Spacer()
            shutdownStatus.onTapGesture {
                if let onToggleAction = onToggleAction {
                    onToggleAction(log)
                }
            }.help(Strings.logHelp.value)
            HStack {
                if(log.edited) {
                    Divider().padding(.leading, 5)
                    editedView
                }
                if let sys = log.systemVersion {
                    Divider()
                    sysVersionView
                }
                Divider()
                energyStatus
                Divider()
                versionView
            }
            if(showDetails) {
                Divider()
                Button {
                    if let url = URL(string: AppScheme.scheme + AppScheme.details + "/" + log.fileName){
                        openURL(url)
                    }
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }.frame(maxHeight: 60)
    }
}

struct LogItemView_Previews: PreviewProvider {

    static var previews: some View {
        LogItemView(
            log: .constant(LogItemInfo.empty),
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogItemInfo.fullNormal),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogItemInfo.fullUnexpected),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogItemInfo.fullUnexpected),
            showDetails: false,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)
    }
}
