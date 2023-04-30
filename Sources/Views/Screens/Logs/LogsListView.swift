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
    
    var analytics: AnalyticsProvider { UptimeLoggerApp.analytics }

    var body: some View {
        VStack(spacing: 0) {
            if(showFilters) {
                HStack(spacing: 20) {
                    Picker(
                        selection: $filterShutdownAllowed,
                        label: Text(.key(.logsFiltersShutdown))
                    ) {
                        Text(.key(.optionsAll))
                            .tag(ThreeCaseState.all)
                        HStack {
                            Image(systemName: LogItemView.iconNormalShutDown)
                            Text(.key(.logsFiltersShutdownN))
                        }.tag(ThreeCaseState.yes)
                        
                        HStack {
                            Image(systemName: LogItemView.iconUnexpected)
                            Text(.key(.logsFiltersShutdownU))
                        }.tag(ThreeCaseState.no)
                        Label(.key(.logNormal), systemImage: LogItemView.iconNormalShutDown).foregroundColor(.green)

                    }
                    .pickerStyle(.menu)

                    Picker(
                        selection: $filterPowerStatus,
                        label: Text(.key(.logsFiltersPower))
                    ) {
                        Text(.key(.optionsAll)).tag(ThreeCaseState.all)
                        HStack {
                            Image(systemName: LogItemView.iconPowerConnected)
                            Text(.key(.logsFiltersPowerOn))
                        }.tag(ThreeCaseState.yes)
                        HStack {
                            Image(systemName: LogItemView.iconPowerDisconnected)
                            Text(.key(.logsFiltersPowerOff))
                        }.tag(ThreeCaseState.no)
                    }
                    .pickerStyle(.menu)

                    Picker(selection: $sortOrder, label: Text(.key(.resultsSort))) {
                        HStack {
                            Image(systemName: "calendar.circle")
                            Text(.key(.logsSortNew))
                        }.tag(LogSortOrder.dateDescending)
                        
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                            Text(.key(.logsSortOld))
                        }.tag(LogSortOrder.dateAscending)
                        
                        HStack {
                            Image(systemName: "hourglass.bottomhalf.fill")
                            Text(.key(.logsSortUpLong))
                        }.tag(LogSortOrder.uptimeDescending)
                        
                        HStack {
                            Image(systemName: "hourglass.tophalf.fill")
                            Text(.key(.logsSortUpShort))
                        }.tag(LogSortOrder.uptimeAscending)
                    }
                    .pickerStyle(.menu)
                    //.frame(maxWidth: 280)
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
                    VStack {
                        LogItemView(
                            log: .constant(logItem),
                            showDetails: true,
                            onToggleAction: onToggleAction
                        )
                        Divider()
                    }//.frame(maxHeight: 10)
                }
            }
        }.onChange(of: sortOrder){ order in
            analytics.event("logs_sort", "sort", _sortOrder.wrappedValue)
        }.onChange(of: filterPowerStatus) { filter in
            analytics.event("logs_filter_power_status", "filter_power_status", _filterPowerStatus.wrappedValue)
        }.onChange(of: filterShutdownAllowed) { filter in
            analytics.event("logs_filter_shutdown_status", "filter_shutdown_status", _filterShutdownAllowed.wrappedValue)
        }.onChange(of: showFilters) { filter in
            analytics.event("logs_show_filter", "show_filter", _showFilters.wrappedValue)
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
