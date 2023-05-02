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
    @AppStorage("showLegend") var showLegend: Bool = false

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
            }
            LogsListView(
                onToggleAction: toggleItemAction,
                items: $logs,
                showFilters: $showFilters
            ).onAppear(perform: initLogs)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(.key(.navLogs))
            if(showLegend) {
                LegendView().padding(.vertical)
            }
            HStack {
                Button(action: {withAnimation(.easeInOut(duration: 0.3)) {
                    showLegend.toggle()
                }}) {
                    Text(.key(.iconsHelp))
                    Image(systemName: "questionmark.circle")
                }
                Spacer()
                HStack {
                    Text("\(logs.count)")
                    Text(.key(.items))
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical)
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
