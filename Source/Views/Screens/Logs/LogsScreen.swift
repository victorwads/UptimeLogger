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

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.defaultLogsFolder
    
    @State private var logs: [LogItemInfo] = []
    @State var showFilters: Bool = false

    let provider: LogsProvider

    var body: some View {
        HStack {
            LegendView().padding()
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showFilters.toggle()
                }
            }) {
                Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
            }
            
        }
        LogsListView(
            onToggleAction: toggleItemAction,
            items: $logs,
            showFilters: $showFilters
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
    }
    
    private func loadLogs() {
        DispatchQueue.global().async {
            logs = provider.loadLogs()
        }
    }
}

struct LogsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogsScreen(provider: LogsProvider())
    }
}
