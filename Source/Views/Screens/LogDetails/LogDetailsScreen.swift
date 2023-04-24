//
//  LogDetailsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct LogDetailsScreen: View {

    let provider: LogsProvider
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
                HeaderView(logFile.fileName, icon: "info") {
                    HStack(spacing: 15) {
                        if let sys = logFile.systemVersion {
                            HStack {
                                Image(systemName: "desktopcomputer")
                                    .foregroundColor(.accentColor)
                                MonoText(sys)
                            }.help("versão do SO")
                        }
                        logView.energyStatus
                        Text("\(processes.count) processes")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
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
                    Text("Esse log não tem informações de processos, cheque as configurações")
                    Text("em caso de duvidas, cheque as configurações")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                LegendView().padding()
            }.handlesExternalEvents(
                preferring: [AppScheme.details + "/" + urlFileName], allowing: [""]
            ).onAppear {
                DispatchQueue.global().async {
                    processes = provider.loadProccessLogFor(filename: urlFileName)
                }
            }.navigationTitle(urlFileName)
        }
    }

    
    private func loadLog(_ filename: String) {
        DispatchQueue.global().async {
            logFile = provider.loadLogWith(filename: filename)
            urlFileName = filename
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
