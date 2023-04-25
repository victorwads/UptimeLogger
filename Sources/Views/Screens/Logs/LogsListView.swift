//
//  LogsView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI
import FirebaseAnalytics

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
                    Picker(
                        selection: $filterPowerStatus,
                        label: Text(.key(.logsOptionsPower))
                    ) {
                        Text(.key(.optionsAll)).tag(ThreeCaseState.all)
                        Image(systemName: LogItemView.iconPowerConnected)
                            .tag(ThreeCaseState.yes)
                            .help(.key(.logsOptionsPowerOn))
                        Image(systemName: LogItemView.iconPowerDisconnected)
                            .tag(ThreeCaseState.no)
                            .help(.key(.logsOptionsPowerOff))
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 230)
                    Picker(
                        selection: $filterShutdownAllowed,
                        label: Text(.key(.logsOptionsShutdown)).padding(.leading)
                    ) {
                        Text(.key(.optionsAll))
                            .tag(ThreeCaseState.all)
                        Text(.key(.logsOptionsShutdownN))
                            .foregroundColor(.green)
                            .tag(ThreeCaseState.yes)
                        Text(.key(.logsOptionsShutdownU))
                            .foregroundColor(.red)
                            .tag(ThreeCaseState.no)
                    }
                    .pickerStyle(.segmented)
                    //.frame(maxWidth: 365)

                    Spacer()
                    Picker(selection: $sortOrder, label: Text(.key(.resultsSort))) {
                        HStack {
                            Image(systemName: "calendar.circle")
                            Text(.key(.logsOptionsSortNew))
                        }.tag(LogSortOrder.dateDescending)
                        
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                            Text(.key(.logsOptionsSortOld))
                        }.tag(LogSortOrder.dateAscending)
                        
                        HStack {
                            Image(systemName: "hourglass.bottomhalf.fill")
                            Text(.key(.logsOptionsSortUpLong))
                        }.tag(LogSortOrder.uptimeDescending)
                        
                        HStack {
                            Image(systemName: "hourglass.tophalf.fill")
                            Text(.key(.logsOptionsSortUpShort))
                        }.tag(LogSortOrder.uptimeAscending)
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 280)
                }.padding()
            }
            if items.isEmpty {
                List([0], id: \.self) { item in
                    HStack(alignment: .center) {
                        Spacer()
                        Text(.key(.logsNotFound)).foregroundColor(.gray)
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
        }.onChange(of: sortOrder){ order in
            Analytics.logEvent("logs_sort", parameters: [
              "name": "sort",
              "full_text": String(describing: _sortOrder.wrappedValue)
            ])
        }.onChange(of: filterPowerStatus) { filter in
            Analytics.logEvent("logs_filter_power_status", parameters: [
              "name": "filter_power_status",
              "full_text": String(describing: _filterPowerStatus.wrappedValue)
            ])
        }.onChange(of: filterShutdownAllowed) { filter in
            Analytics.logEvent("logs_filter_shutdown_status", parameters: [
              "name": "filter_shutdown_status",
              "full_text": String(describing: _filterShutdownAllowed.wrappedValue)
            ])
        }.onChange(of: showFilters) { filter in
            Analytics.logEvent("logs_show_filter", parameters: [
              "name": "show_filter" as NSObject
            ])
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