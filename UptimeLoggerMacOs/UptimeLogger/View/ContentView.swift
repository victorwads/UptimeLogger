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
    @Binding var allowState: Bool
    var toggleShutdownAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Logs")
                        .font(.title)
                        .foregroundColor(.gray)
                    Text(logsFolder)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    Button(action: toggleShutdownAction) {
                        Label(
                            title: { Text(
                                allowState ? "Deny Shutdown" : "Allow ShutDown"
                            ) },
                            icon: { Image(
                                systemName: allowState ? "xmark.circle.fill" : "checkmark.circle.fill"
                            ) }
                        )
                    }
                    HStack() {
                        Text("Current Shutdown Allowed:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(allowState ? "Yes" : "No")
                            .font(.subheadline)
                            .foregroundColor(allowState ? .green : .red)
                        Image(
                            systemName: allowState
                            ? "checkmark.circle.fill" : "xmark.circle.fill"
                        ).foregroundColor(allowState ? .green : .red)
                    }
                }
            }
            
            LogsView(items: $logs)
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
                LogItemInfo(fileName: "fds", content: "test")
            ]),
            logsFolder: .constant("Some Path"),
            allowState: .constant(true),
            toggleShutdownAction: {}
        )
    }
}

