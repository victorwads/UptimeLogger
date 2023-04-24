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
    @State var showFilters: Bool

    init(provider: LogsProvider, showFilters: Bool = false){
        self.provider = provider
        _showFilters = State(initialValue: showFilters)
    }

    let provider: LogsProvider

    var body: some View {
        HeaderView("Registros", icon: "list.bullet.rectangle") {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showFilters.toggle()
                }
            }) {
                Text("Opções")
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
        if(provider.isReadable) {
            loadLogs()
            return
        }
        FilesProvider.shared.authorize(provider.folder, false) {_ in
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
