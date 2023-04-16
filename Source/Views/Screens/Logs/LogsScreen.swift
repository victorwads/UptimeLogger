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

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.defaultLogsFolder
    
    let provider: LogsProvider
    let showInstallation: () -> Void

    var body: some View {
            LegendView().padding()
            LogsListView(
                onToggleAction: toggleItemAction,
                items: $logs
            ).onAppear(perform: initLogs)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Strings.mainLogs.value)
    }
    
    private func toggleItemAction(item: LogItemInfo) {
        provider.toggleShutdownAllowed(item)
        loadLogs()
    }
    
    private func initLogs(){
        provider.folder = logsFolder
        FilesProvider.shared.authorize(logsFolder, false) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
        }
        
        serviceInstalled = provider.isServiceInstalled
    }
    
    private func loadLogs() {
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
