//
//  LogsListScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

class TimerWrapper {
    public var timer: Timer?
}

struct LogsScreen: View {

    @State private var serviceInstalled: Bool = false
    @State private var logs: [LogItemInfo] = []
    @State private var currentLog: LogItemInfo = LogItemInfo()

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.defaultLogsFolder
    
    let provider: LogsProvider
    let showInstallation: () -> Void

    private let wrapper = TimerWrapper()

    var body: some View {
            VStack {
                ContentView(
                    logs: $logs,
                    logsFolder: $logsFolder,
                    current: $currentLog,
                    toggleItemAction: {item in
                        provider.toggleShutdownAllowed(item)
                        loadLogs()
                    }
                )
                LegendView()
            }.onAppear(perform: self.initLogs)
            .onDisappear(perform: {
                wrapper.timer?.invalidate()
                wrapper.timer = nil
            })
    }
    
    private func initLogs(){
        provider.folder = logsFolder
        FilesProvider.shared.authorize(logsFolder, false) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
        }
        
        serviceInstalled = provider.isServiceInstalled
        
        wrapper.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            loadCurrent()
        }
        wrapper.timer?.fire()
    }
    
    private func loadCurrent() {
        var current = provider.loadCurrentLog()
        currentLog = current
    }

    private func loadLogs() {
        loadCurrent()
        DispatchQueue.global().async {
            logs = provider.loadLogs()
            
            if(!serviceInstalled && logs.count < 1) {
                showInstallation()
            }
        }
    }
}

struct LogsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreen(
            provider: LogsProvider(),
            showInstallation: {}
        )
    }
}
