//
//  LogItemView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogItemView: View {
    
    @Binding var log: LogItemInfo

    var onToggleAction: (LogItemInfo) -> Void
    var allowText: String = "Mark Allowed"
    var denyText: String = "Mark Denied"
    
    private var allow: Bool {
        get {
            log.shutdownAllowed
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading){
                HStack(alignment: .center) {
                    Image(systemName: "power")
                    Text("StartUp:").bold()
                    Text("\(log.formattedStartUptime)")
                }
                HStack(alignment: .center) {
                    Image(systemName: "clock")
                    Text("Uptime:").bold()
                    Text("\(log.formattedUptime)")
                }
            }
            Spacer()
            HStack(alignment: .center) {
                Text("Shutdown Allowed:").bold()
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(allow ? "Yes" : "No")
                    .foregroundColor(allow ? .green : .red)
                Image(systemName: allow ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(allow ? .green : .red)
            }
            Spacer()
            Button(action: { onToggleAction(log) }) {
                Label(
                    title: { Text(allow ? denyText : allowText) },
                    icon: { Image(
                        systemName: allow ? "xmark.circle.fill" : "checkmark.circle.fill"
                    ) }
                )
            }

        }
    }
}

struct LogItemView_Previews: PreviewProvider {
    static var previews: some View {
        LogItemView(
            log: .constant(LogItemInfo(fileName: "", content: "")),
            onToggleAction: {_ in }
        )
    }
}
