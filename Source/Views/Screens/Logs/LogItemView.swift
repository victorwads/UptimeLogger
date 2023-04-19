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
                    MonoText(text: log.formattedStartUptime)
                }.padding(.bottom, 2)
            }
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconBootTime)
                    .foregroundColor(.accentColor)
                MonoText(text: log.formattedBoottime ?? "null")
            }
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconUpTime)
                    .foregroundColor(.accentColor)
                MonoText(text: log.formattedUptime)
            }
            Spacer()


            shutdownStatus.onTapGesture {
                if let onToggleAction = onToggleAction {
                    onToggleAction(log)
                }
            }.help(Strings.logHelp.value)
            if(log.edited) {
                Divider().padding(.leading, 5)
                Image(systemName: LogItemView.iconEdited)
                    .help(Strings.logEditedTip.value)
            }
            HStack {
                if let sys = log.systemVersion {
                    Divider()
                    HStack {
                        Image(systemName: "desktopcomputer")
                            .foregroundColor(.accentColor)
                        MonoText(text: sys)
                    }.help("versão do SO")
                }
                if let battery = log.batery, let charging = log.charging {
                    Divider()
                    Battery(level: battery)
                    Image(systemName: charging ? "bolt.fill" : "bolt.slash.fill")
                        .help(charging ? "conectado a energia" : "desconectado da energia")
                    Divider()
                }
            }
            Text("v\(log.version)")
                .foregroundColor(.gray)
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
        }
    }
}

struct MonoText: View {
    
    let text: String
    
    var body: some View {
        let text = Text(text)
            .font(.headline)
        if #available(macOS 13.0, *){
            text.monospaced()
        }
    }
}

struct LogItemView_Previews: PreviewProvider {

    static var previews: some View {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let content = """
version: 4
init: 2023-04-17_00-13-40
ended: 2023-04-17_00-13-43
sysversion: 13.4
batery: 72%
charging: false
boottime: 1681697439
uptime: 3784
logprocessinterval: 2
logprocess: true
"""

        LogItemView(
            log: .constant(LogItemInfo(fileName: fileName, content: content)),
            onToggleAction: {_ in }
        )

        let content2 = """
version: 4
init: 2023-04-17_00-13-40
ended: 2023-04-17_00-13-43
sysversion: 13.4
batery: 72%
charging: false
boottime: 1681697439
uptime: 3784
logprocessinterval: 2
logprocess: true
"""
        LogItemView(
            log: .constant(LogItemInfo(fileName: fileName, content: content2)),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1500, maxHeight: 60)
    }
}
