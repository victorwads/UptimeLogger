//
//  LogsView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogsView: View {
    
    @Binding var items: [LogItemInfo]?

    var body: some View {
        if items == nil {
            List([0], id: \.self) { item in
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                }
            }
        } else if items?.isEmpty ?? false {
            List([0], id: \.self) { item in
                HStack(alignment: .center) {
                    Spacer()
                    Text("No logs found.").foregroundColor(.gray)
                    Spacer()
                }
            }
        } else if let logItems = items {
            List(logItems, id: \.startUpTime) { logItem in
                LogItemView(log: .constant(logItem))
            }
        }
    }

}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView(items: .constant([
            LogItemInfo(fileName: "", content: "")
        ]))
    }
}