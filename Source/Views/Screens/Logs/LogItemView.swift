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

    @Binding var log: LogItemInfo
    var onToggleAction: ((LogItemInfo) -> Void)? = nil
    
    private var allow: Bool {
        get { log.shutdownAllowed }
    }
    
    var shutdownStatus: some View {
        HStack(alignment: .center, spacing: 4) {
            let info = (!allow ? Strings.logUnexpectedYes.value : Strings.logUnexpectedNo.value) + log.formattedEndtime
            Text(info)
                .foregroundColor(allow ? .green : .red)
            Image(systemName: allow ? LogItemView.iconNormalShutDown : LogItemView.iconUnexpected)
                .font(.headline)
                .foregroundColor(allow ? .green : .red)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconScriptStartTime)
                    .foregroundColor(.accentColor)
                MonoText(text: log.formattedStartUptime)
            }.padding(.bottom, 2)
            HStack(alignment: .center) {
                Image(systemName: LogItemView.iconShutdownTime)
                    .foregroundColor(.accentColor)
                MonoText(text: log.formattedShutdownTime ?? "null")
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
            Text(Strings.logUnexpected.value).bold()
                .font(.subheadline)
                .foregroundColor(.gray)

            if let onToggleAction = onToggleAction {
                shutdownStatus.onTapGesture {
                    onToggleAction(log)
                }.help(Strings.logHelp.value)
                if(log.edited) {
                    Divider().padding(.leading, 5)
                    Image(systemName: LogItemView.iconEdited)
                        .help(Strings.logEditedTip.value)
                }
                Divider()
            } else {
                shutdownStatus
            }
            Text("v\(log.version)")
                .foregroundColor(.gray)
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
        LogItemView(
            log: .constant(LogItemInfo(fileName: "", content: "")),
            onToggleAction: {_ in }
        )
    }
}
