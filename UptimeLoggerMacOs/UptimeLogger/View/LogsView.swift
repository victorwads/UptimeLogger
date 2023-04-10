//
//  LogsView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogsView: View {
    @State private var logItems: [LogItemInfo]? = nil

    var body: some View {
        if logItems == nil {
            List([0], id: \.self) { item in
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                }
            }.onAppear() {
                load()
            }
        } else if logItems?.isEmpty ?? false {
            List([0], id: \.self) { item in
                HStack(alignment: .center) {
                    Spacer()
                    Text("No logs found.").foregroundColor(.gray)
                    Spacer()
                }
            }
        } else if let logItems = logItems {
            List(logItems, id: \.startUpTime) { logItem in
                HStack(alignment: .center) {
                    Image(systemName: "power")
                    Text("StartUp:").bold()
                    Text("\(logItem.formattedStartUptime)")
                }
                HStack(alignment: .center) {
                    Image(systemName: "clock")
                    Text("Uptime:").bold()
                    Text("\(logItem.formattedUptime)")
                }
                Divider()
            }
        }
        Button("Reload"){ load() }
    }
    
    private func load() {
        self.logItems = nil
        DispatchQueue.global().async {
            var results: [LogItemInfo] = []
            let logFiles = FileManager.default.enumerator(atPath: LogsProvider.folder)?.allObjects as? [String] ?? []
            let logFilePaths = logFiles.filter { $0.hasSuffix(".txt") }.map { $0 }
            
            for logFilePath in logFilePaths {
                if let logData = FileManager.default.contents(atPath: LogsProvider.folder+logFilePath),
                   let log = String(data: logData, encoding: .utf8) {
                    results.append(
                        LogItemInfo(fileName: logFilePath, content: log)
                    )
                }
            }
            self.logItems = results.sorted(by: { $0.startUpTime > $1.startUpTime })
        }
    }
}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
    }
}
