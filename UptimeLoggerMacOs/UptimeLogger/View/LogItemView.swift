//
//  LogItemView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogItemView: View {
    
    @Binding var log: LogItemInfo
    
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
                Text(log.shutdownAllowed ? "Yes" : "No")
                    .foregroundColor(log.shutdownAllowed ? .green : .red)
                Image(
                    systemName: log.shutdownAllowed
                    ? "checkmark.circle.fill" : "xmark.circle.fill"
                ).foregroundColor(log.shutdownAllowed ? .green : .red)
            }
        }
        
        Divider()
    }
}

struct LogItemView_Previews: PreviewProvider {
    static var previews: some View {
        LogItemView(log: .constant(
            LogItemInfo(fileName: "", content: "")
        ))
    }
}
