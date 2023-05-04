//
//  LogItemView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogItemView: View {
    static let iconNormalShutDown = "checkmark.circle.fill"
    static let iconUnexpected = "bolt.trianglebadge.exclamationmark.fill"
    static let iconScriptStartTime = "gearshape.arrow.triangle.2.circlepath"
    static let iconShutdownTime = "powersleep"
    static let iconBootTime = "power"
    static let iconActive = "timer"
    static let iconUpTime = "power"//arrow.up.circle.badge.clock"
    static let iconSuspendedTime = "moon.zzz"
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

    var suspendedTimeView: some View  {
        HStack(alignment: .center) {
            Image(systemName: LogItemView.iconSuspendedTime)
                .foregroundColor(.accentColor)
            MonoText(log.formattedSuspendedTime)
        }
    }

    var activeTimeView: some View  {
        HStack(alignment: .center) {
            Image(systemName: LogItemView.iconActive)
                .foregroundColor(.accentColor)
            MonoText(log.formattedActiveTime)
        }
    }

    var shutdownStatus: some View {
        HStack(alignment: .center, spacing: 4) {
            MonoText(log.formattedEndtime)
                //.foregroundColor(allow ? .green : .red)
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
                    .help(.key(charging ? .logsFiltersPowerOn : .logsFiltersPowerOff))
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
                }.help(.key(.logSysVersion))
            }
        }
    }

    var versionView: some View {
        Text("v\(log.version)")
            .foregroundColor(.gray)
    }

    var editedView: some View {
        Text(.key(.logEdited))
            .font(.subheadline)
            .foregroundColor(.gray)
//        Image(systemName: LogItemView.iconEdited)
//            .help(.key(.logEdited))
    }

    var body: some View {
        HStack(alignment: .center) {
            if(!showDetails) {
                initScriptView.padding(.bottom, 2)
            }
//            bootTimeView
            upTimeView
            if(log.systemActivetime != nil) {
                activeTimeView
                suspendedTimeView
            }
            Spacer()
            HStack {
                if(log.edited) {
//                    Divider().padding(.leading, 5)
                    editedView
                }
                shutdownStatus.onTapGesture {
                    if let onToggleAction = onToggleAction {
                        onToggleAction(log)
                    }
                }
                .help(.key(.logHelp))
//                if log.systemVersion != nil {
//                    Divider()
//                    sysVersionView
//                }
//                Divider()
//                energyStatus
//                Divider()
//                versionView
            }
            if(showDetails) {
                Button {
                    if let url = URL(string: AppScheme.scheme + AppScheme.details + "/" + log.fileName){
                        openURL(url)
                    }
                } label: {
                    Image(systemName: "chevron.forward")
                }
                .buttonStyle(.plain)
                .help(.key(.logsDetails))
                .padding()
            }
        }.frame(maxHeight: 45)
    }
}

struct LogItemView_Previews: PreviewProvider {

    static var previews: some View {
        LogItemView(
            log: .constant(LogsProviderMock.empty),
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogsProviderMock.fullNormal),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogsProviderMock.fullUnexpected),
            showDetails: true,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)

        LogItemView(
            log: .constant(LogsProviderMock.fullUnexpected),
            showDetails: false,
            onToggleAction: {_ in }
        ).frame(minWidth: 1200)
    }
}
