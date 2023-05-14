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

    @State private var logs: [LogItemInfo] = []
    @AppStorage("showFilters") var showFilters: Bool = true

    init(provider: LogsProvider, showFilters: Bool = true){
        self.provider = provider
        _showFilters.wrappedValue = showFilters
    }

    let provider: LogsProvider

    var body: some View {
        VStack(spacing: 0){
            HeaderView(.key(.navLogs), icon: MenuView.iconLogs) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFilters.toggle()
                    }
                }) {
                    Text(.key(.logsFilters))
                    Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                }
                Button(action: loadLogs) {
                    Text(.key(.reload))
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
            }
            LogsListView(
                onToggleAction: toggleItemAction,
                items: $logs,
                showFilters: $showFilters
            ).onAppear(perform: initLogs)
                .navigationTitle(.key(.navLogs))
        }
    }
    
    private func toggleItemAction(item: LogItemInfo) {
        provider.ifCanWrite {
            provider.toggleShutdownAllowed(item)
            loadLogs()
        }
    }
    
    private func initLogs(){
        provider.ifCanRead(finish: true) {
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
        VStack {
            LogsScreen(
                provider: LogsProviderMock()
            )
        }.frame(width: 1000, height: 700)
        VStack {
            LogsScreen(
                provider: LogsProviderMock(),
                showFilters: true
            )
        }.frame(width: 1000, height: 700)
    }
}
