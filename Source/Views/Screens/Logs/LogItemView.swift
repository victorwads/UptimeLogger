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

    @Environment(\.openURL) var openURL
    
    @Binding var log: LogItemInfo
    var showDetails: Bool = false
    var onToggleAction: ((LogItemInfo) -> Void)? = nil

    private var allow: Bool {
        get { log.shutdownAllowed }
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
    
    var body: some View {
        HStack(alignment: .center) {
            if(!showDetails) {
                HStack(alignment: .center) {
                    Image(systemName: LogItemView.iconScriptStartTime)
                        .foregroundColor(.accentColor)
                    MonoText(log.formattedStartUptime)
                }.padding(.bottom, 2)
            }
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconBootTime)
                    .foregroundColor(.accentColor)
                MonoText(log.formattedBoottime ?? "null")
            }
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconUpTime)
                    .foregroundColor(.accentColor)
                MonoText(log.formattedUptime)
            }
            Spacer()

            shutdownStatus.onTapGesture {
                if let onToggleAction = onToggleAction {
                    onToggleAction(log)
                }
            }.help(Strings.logHelp.value)
            HStack {
                if(log.edited) {
                    Divider().padding(.leading, 5)
                    Image(systemName: LogItemView.iconEdited)
                        .help(Strings.logEditedTip.value)
                }
                if let sys = log.systemVersion {
                    Divider()
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(.accentColor)
                        MonoText(sys)
                    }.help("versão do SO")
                }
                if let battery = log.batery, let charging = log.charging {
                    Divider()
                    Battery(level: battery)
                    Image(systemName: charging ? "bolt.fill" : "bolt.slash.fill")
                        .help(charging ? "conectado a energia" : "desconectado da energia")
                }
                Divider()
                Text("v\(log.version)")
                    .foregroundColor(.gray)
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
        ).frame(minWidth: 1000)

        LogItemView(
            log: .constant(LogItemInfo.fullNormal),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1000)

        LogItemView(
            log: .constant(LogItemInfo.fullUnexpected),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1000)
    }
}
