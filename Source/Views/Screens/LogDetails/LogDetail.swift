//
//  LogDetail.swift
//  UptimeLogger
//
//  Created by Victor Wads on 17/04/23.
//

import SwiftUI

struct LogDetail: View {

    let provider: LogsProvider
    
    @State var proccess: [String] = []
    @State var logFile: LogItemInfo = LogItemInfo.empty
    @SceneStorage("windowDeepLink") var urlFileName: String = ""

    var body: some View {
        if(urlFileName.isEmpty || logFile.fileName.isEmpty) {
            VStack {
                ProgressView()
            }.onOpenURL { url in
                loadLog(url.lastPathComponent)
            }.onChange(of: urlFileName) { new in
                if(!new.isEmpty && logFile.fileName.isEmpty) {
                    loadLog(urlFileName)
                }
            }
        } else {
            LogDetailView(
                proccess: $proccess,
                logFile: $logFile,
                urlFileName: $urlFileName
            ).handlesExternalEvents(
                preferring: [AppScheme.details + "/" + urlFileName], allowing: [""]
            ).onAppear {
                DispatchQueue.global().async {
                    proccess = provider.loadProccessLogFor(filename: urlFileName)
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

fileprivate struct LogDetailView: View {

    @Binding var proccess: [String]
    @Binding var logFile: LogItemInfo
    @Binding var urlFileName: String

    var body: some View {
        VStack(spacing: 0) {
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
                List {
                    if(proccess.count == 0){
                        ProgressView()
                    } else {
                        ForEach(proccess, id: \.self) { item in
                            MonoText(text: item)
                        }
                    }
                }
            } else {
                Spacer()
                Text("Esse log não tem informações de processos, cheque as configurações")
                Text("em caso de duvidas, cheque as configurações")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct LogDetail_Previews: PreviewProvider {
    static var previews: some View {
        LogDetailView(
            proccess: .constant([]),
            logFile: .constant(LogItemInfo.empty),
            urlFileName: .constant("Filename")
        ).frame(width: 1000, height: 500)
        LogDetail(
            provider: LogsProvider(),
            urlFileName: "fsdg"
        ).frame(width: 500, height: 200)
    }
}
