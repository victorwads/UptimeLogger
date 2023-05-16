//
//  LogDetailsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

fileprivate enum Details {
    case details
    case battery
    case processes
    case suspensions
}

struct LogDetailsScreen: View {

    let provider: LogsProvider
    let current: Bool = false
    @SceneStorage("windowDeepLink") var urlFileName: String = ""

    @State fileprivate var showing: Details = .details
    @State var processes: [ProcessLogInfo] = []
    @State var logFile: LogItemInfo = LogsProviderMock.empty

    var body: some View {
        if(logFile.fileName.isEmpty) {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }.onOpenURL { url in
                loadLog(url.lastPathComponent)
            }.onChange(of: urlFileName) { new in
                if(!new.isEmpty && logFile.fileName.isEmpty) {
                    loadLog(urlFileName)
                }
            }
        } else {
            let logView = LogItemView(log: $logFile)
            VStack {
                HeaderView(LocalizedStringKey(logFile.formattedEndtime), icon: "info") {
                    HStack(spacing: 15) {
                        if(logFile.edited) {
                            logView.editedView
                        }
                        if let sys = logFile.systemVersion {
                            HStack {
                                Image(systemName: "desktopcomputer")
                                    .foregroundColor(.accentColor)
                                MonoText(sys)
                            }.help(.key(.logSysVersion))
                        }
                        logView.energyStatusView
                    }.animation(.default)
                }
                if (logFile.hasProcess || logFile.hasBatteryHistory || logFile.hasSuspensions) {
                    Picker("", selection: $showing) {
                        Text("details").tag(Details.details)
                        if(logFile.batteryHistory.count > 1){
                            Text("battery").tag(Details.battery)
                        }
                        if(logFile.hasProcess) {
                            Text("processes").tag(Details.processes)
                        }
                        if(logFile.hasSuspensions) {
                            Text("suspensions").tag(Details.suspensions)
                        }
                    }.pickerStyle(.segmented)
                        .padding(.top)
                }
                
                switch showing {
                case .details:
                    Spacer()
                    VStack(spacing: 20) {
                        Text("TODO")
                        HStack(spacing: 20) {
                            logView.bootTimeView
                            Spacer()
                            logView.upTimeView
                        }
                        HStack(spacing: 20) {
                            logView.initScriptView
                            Spacer()
                            logView.activeTimeView
                        }
                        HStack(spacing: 20) {
                            logView.shutdownStatusView
                            Spacer()
                            logView.suspendedTimeView
                        }
                    }.frame(maxWidth: 400)
                    Spacer()
                    LegendView().padding()
                case .battery:
                    BatteryGraph(batteryLevels: logFile.batteryHistory)
                case .processes:
                    if(processes.count == 0){
                        Spacer()
                        ProgressView()
                        Spacer()
                        .onAppear(perform: loadProcesses)
                    } else {
                        ProcessView(proccess: $processes)
                    }
                case .suspensions:
                    List(logFile.suspensions.keys.enumerated().map { $0.element }, id: \.self) { date in
                        HStack {
                            Image(systemName: LogItemView.iconSuspendedTime)
                                .foregroundColor(.accentColor)
                            Text(logFile.suspensions[date]!.formatInterval())
                            Spacer()
                            Text("\(date)")
                        }
                        .font(.caption)
                        Divider()
                    }
                    .listStyle(InsetListStyle())
                    Text("TODO")
                }
            }.handlesExternalEvents(
                preferring: [AppScheme.details + "/" + urlFileName], allowing: [""]
            )
            
            .navigationTitle(urlFileName)
        }
    }

    private func loadProcesses() {
        DispatchQueue.global(qos: .background).async {
            let all = provider.loadProccessLogFor(log: logFile)
            DispatchQueue.main.async {
                processes = all
            }
        }
    }

    private func loadLog(_ filename: String) {
        DispatchQueue.global(qos: .background).async {
            let result = provider.loadLogWith(filename: filename)
            DispatchQueue.main.async {
                logFile = result
                urlFileName = filename
            }
        }
    }
}


struct LogDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogDetailsScreen(
            provider: LogsProviderMock(),
            urlFileName: "mockFileName",
            logFile: LogsProviderMock.fullNormal
        ).frame(width: 1000, height: 700)
        LogDetailsScreen(
            provider: LogsProviderMock(),
            urlFileName: "mockFileName",
            logFile: LogsProviderMock.fullUnexpected
        ).frame(width: 1000, height: 700)
    }
}
