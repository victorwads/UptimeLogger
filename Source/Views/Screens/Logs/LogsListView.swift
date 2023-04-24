//
//  LogsView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogsListView: View {
    
    var onToggleAction: (LogItemInfo) -> Void = {_ in }
    @Binding var items: [LogItemInfo]

    @Binding var showFilters: Bool
    @State private var sortOrder: LogSortOrder = .dateDescending
    @State private var filterPowerStatus: ThreeCaseState = .all
    @State private var filterShutdownAllowed: ThreeCaseState = .all

    var body: some View {
        VStack(spacing: 0) {
            if(showFilters) {
                HStack {
                    Picker(selection: $filterPowerStatus, label: Text("Power Status:")) {
                        Text("All").tag(ThreeCaseState.all)
                        Image(systemName: LogItemView.iconPowerConnected)
                            .tag(ThreeCaseState.yes)
                            .help("Power connected")
                        Image(systemName: LogItemView.iconPowerDisconnected)
                            .tag(ThreeCaseState.no)
                            .help("Power disconnected")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 220)
                    Picker(selection: $filterShutdownAllowed, label:
                            Text("Shutdown Status:").padding(.leading)
                    ) {
                        Text("All").tag(ThreeCaseState.all)
                        Text("Normal").foregroundColor(.green).tag(ThreeCaseState.yes)
                        Text("Unexpected").foregroundColor(.red).tag(ThreeCaseState.no)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 350)

                    Spacer()
                    Picker(selection: $sortOrder, label: Text("Sort by:")) {
                        HStack {
                            Image(systemName: "calendar.circle")
                            Text("Newest first")
                        }.tag(LogSortOrder.dateDescending)
                        
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                            Text("Oldest first")
                        }.tag(LogSortOrder.dateAscending)
                        
                        HStack {
                            Image(systemName: "hourglass.bottomhalf.fill")
                            Text("Uptime (longest first)")
                        }.tag(LogSortOrder.uptimeDescending)
                        
                        HStack {
                            Image(systemName: "hourglass.tophalf.fill")
                            Text("Uptime (shortest first)")
                        }.tag(LogSortOrder.uptimeAscending)
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 200)
                }.padding()
            }
            if items.isEmpty {
                List([0], id: \.self) { item in
                    HStack(alignment: .center) {
                        Spacer()
                        Text(Strings.logsNotFound.value).foregroundColor(.gray)
                        Spacer()
                    }
                }
            } else {
                List(
                    items.filter(filterFunction).sorted(by: sortingFunction),
                    id: \.fileName
                ) { logItem in
                    LogItemView(
                        log: .constant(logItem),
                        showDetails: true,
                        onToggleAction: onToggleAction
                    )
                    Divider()
                }
            }
            if(showFilters) {
                LegendView().padding(.vertical)
            }
        }
    }
    
    private var sortingFunction: (LogItemInfo, LogItemInfo) -> Bool {
        switch sortOrder {
        case .dateAscending:
            return { $0.systemBootTime ?? Date.distantPast < $1.systemBootTime ?? Date.distantPast }
        case .dateDescending:
            return { $0.systemBootTime ?? Date.distantPast > $1.systemBootTime ?? Date.distantPast }
        case .uptimeAscending:
            return { $0.systemUptime ?? 0 < $1.systemUptime ?? 0 }
        case .uptimeDescending:
            return { $0.systemUptime ?? 0 > $1.systemUptime ?? 0 }
        }
    }

    
    private var filterFunction: (LogItemInfo) -> Bool {
        return { logItem in
            if filterPowerStatus != .all && logItem.charging != filterPowerStatus.bool {
                return false
            }
            if filterShutdownAllowed != .all && logItem.shutdownAllowed != filterShutdownAllowed.bool {
                return false
            }
            return true
        }
    }

}

enum LogSortOrder {
    case dateDescending
    case dateAscending
    case uptimeDescending
    case uptimeAscending
}



struct LogsView_Previews: PreviewProvider {
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
