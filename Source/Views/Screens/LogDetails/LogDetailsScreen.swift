//
//  LogDetailsScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct LogDetailsScreen: View {

    let provider: LogsProvider
    
    @State var processes: [ProcessLogInfo] = []
    @State var logFile: LogItemInfo = LogItemInfo.empty
    @SceneStorage("windowDeepLink") var urlFileName: String = ""

    var body: some View {
        if(urlFileName.isEmpty || logFile.fileName.isEmpty) {
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
            VStack {
                HStack {
                    Text(urlFileName)
                        .font(.title)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                LogItemView(log: $logFile)
                    .padding(.horizontal)
                    .frame(maxHeight: 50)
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
            }.handlesExternalEvents(
                preferring: [AppScheme.details + "/" + urlFileName], allowing: [""]
            ).onAppear {
                DispatchQueue.global().async {
                    processes = provider.loadProccessLogFor(filename: urlFileName)
                }
            }
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
            provider: LogsProvider(),
            urlFileName: "fsdg"
        ).frame(width: 500, height: 200)    }
}
