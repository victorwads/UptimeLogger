//
//  LogDetailsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct LogDetailsScreen: View {

    let provider: LogsProvider
    let current: Bool = false
    @SceneStorage("windowDeepLink") var urlFileName: String = ""

    @State var processes: [ProcessLogInfo] = []
    @State var logFile: LogItemInfo = LogItemInfo.empty

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
                HeaderView(LocalizedStringKey(logFile.fileName), icon: "info") {
                    HStack(spacing: 15) {
                        if let sys = logFile.systemVersion {
                            HStack {
                                Image(systemName: "desktopcomputer")
                                    .foregroundColor(.accentColor)
                                MonoText(sys)
                            }.help(.key(.logSysVersion))
                        }
                        logView.energyStatus
                        if(processes.count > 0){
                            Text("\(processes.count) items")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .transition(.scale)
                        }
                    }.animation(.default)
                }
                HStack(spacing: 20) {
                    logView.bootTimeView
                    logView.upTimeView
                    logView.initScriptView
                    Spacer()
                    logView.shutdownStatus
                    if(logFile.edited) {
                        logView.editedView
                    }
                }.padding()

                if(logFile.hasProcess) {
                    if(processes.count == 0){
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else {
                        ProcessView(proccess: $processes)
                    }
                } else {
                    Spacer()
                    Text(.key(.detailsNotFound))
                    Text(.key(.detailsNotFoundTip))
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                LegendView().padding()
            }.handlesExternalEvents(
                preferring: [AppScheme.details + "/" + urlFileName], allowing: [""]
            )
            .onAppear(perform: loadProcesses)
            .navigationTitle(urlFileName)
        }
    }

    private func loadProcesses() {
        DispatchQueue.global(qos: .background).async {
            let all = provider.loadProccessLogFor(filename: logFile.fileName)
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
            logFile: LogItemInfo.fullNormal
        ).frame(width: 1000, height: 700)
        LogDetailsScreen(
            provider: LogsProviderMock(),
            urlFileName: "mockFileName",
            logFile: LogItemInfo.fullUnexpected
        ).frame(width: 1000, height: 700)
    }
}
