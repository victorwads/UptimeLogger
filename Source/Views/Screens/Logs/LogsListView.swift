//
//  LogsView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct TextIconView: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
            Image(systemName: icon)
        }
    }

}
struct LogsListView: View {
    
    var onToggleAction: (LogItemInfo) -> Void = {_ in }
    @Binding var items: [LogItemInfo]

    @Binding var showFilters: Bool
    @State private var sortOrder: LogSortOrder = .dateDescending
    @State private var filterPowerStatus: TreeCase = .all
    @State private var filterShutdownAllowed: TreeCase = .all
    
    enum LogSortOrder {
        case dateDescending
        case dateAscending
        case uptimeDescending
        case uptimeAscending
    }

    enum TreeCase {
        case all
        case yes
        case no
        
        var state: Bool? {
            switch self {
            case .all:
                return nil
            case .yes:
                return true
            case .no:
                return false
            }
        }
    }


    var body: some View {
        VStack {
            if(showFilters) {
                VStack {
                    HStack {
                        Text("Sort by:")
                        Picker(selection: $sortOrder, label: Text("")) {
                            Text("Date (newest first)").tag(LogSortOrder.dateDescending)
                            Text("Date (oldest first)").tag(LogSortOrder.dateAscending)
                            Text("Uptime (longest first)").tag(LogSortOrder.uptimeDescending)
                            Text("Uptime (shortest first)").tag(LogSortOrder.uptimeAscending)
                        }
                        .pickerStyle(.segmented)
                    }.padding(.horizontal)
                    HStack {
                        Picker(selection: $filterPowerStatus, label: Text("Charging Status:")) {
                            Text("All").tag(TreeCase.all)
                            Image(systemName: "bolt.fill")
                                .tag(TreeCase.yes)
                                .help("Power connected")
                            Image(systemName: "bolt.slash.fill")
                                .tag(TreeCase.no)
                                .help("Power disconnected")
                        }
                        .pickerStyle(.segmented)
                        Spacer()
                        Picker(selection: $filterShutdownAllowed, label: Text("Shutdown:")) {
                            Text("All").tag(TreeCase.all)
                            Text("Normal").tag(TreeCase.yes)
                            Text("Unexpected").tag(TreeCase.no)
                        }
                        .pickerStyle(.segmented)
                    }.padding(.horizontal)
                }
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
            if filterPowerStatus != .all && logItem.charging != filterPowerStatus.state {
                return false
            }
            if filterShutdownAllowed != .all && logItem.shutdownAllowed != filterShutdownAllowed.state {
                return false
            }
            return true
        }
    }

}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsListView(items: .constant([
            LogItemInfo(fileName: "", content: ""),
        ]),
             showFilters: .constant(true)
        )
    }
}
