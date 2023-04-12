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
    var informed: Bool {
        get { current.shutdownAllowed }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Strings.mainCurrent.value)
                .font(.title)
                .foregroundColor(.gray)
            Text(Strings.mainCurrentInfo.value)

            Divider().padding(.top, 10)
            LogItemView(
                log: $current
            )
            .padding(10)
            .padding(.horizontal, 20)
            Divider()
                .padding(.bottom, 20)
            
            HStack {
                Text(Strings.mainLogs.value)
                    .font(.title)
                    .foregroundColor(.gray)
                Spacer()
                Text(logsFolder)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
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
    static var item = LogItemInfo()
    static var previews: some View {
        ContentView(
            logs: .constant([item]),
            logsFolder: .constant("Some Path"),
            current: .constant(item)
        )
    }
}

