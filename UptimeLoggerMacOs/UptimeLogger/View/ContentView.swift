//
//  ContentView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var logs: [LogItemInfo]?
    @Binding var logsFolder: String
    @Binding var current: LogItemInfo
    var toggleCurrentAction: () -> Void = { }
    var toggleItemAction: (LogItemInfo) -> Void = {_ in }
    var allowState: Bool {
        get { current.shutdownAllowed }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Current")
                        .font(.title)
                        .foregroundColor(.gray)
                    LogItemView(
                        log: $current,
                        onToggleAction: {_ in toggleCurrentAction()},
                        allowText: "Allow ShutDown",
                        denyText: "Deny ShutDown"
                    )
                }
            }
            Text("Logs")
                .font(.title)
                .foregroundColor(.gray)
            Text(logsFolder)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            LogsView(
                onToggleAction: toggleItemAction,
                items: $logs
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            logs: .constant([
                LogItemInfo(fileName: "", content: "shutdown allowed"),
                LogItemInfo()
            ]),
            logsFolder: .constant("Some Path"),
            current: .constant(LogItemInfo())
        )
    }
}

