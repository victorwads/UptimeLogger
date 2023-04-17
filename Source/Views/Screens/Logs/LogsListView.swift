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

    var body: some View {
        if items.isEmpty {
            List([0], id: \.self) { item in
                HStack(alignment: .center) {
                    Spacer()
                    Text(Strings.logsNotFound.value).foregroundColor(.gray)
                    Spacer()
                }
            }
        } else {
            List(items, id: \.fileName) { logItem in
                LogItemView(
                    log: .constant(logItem),
                    onToggleAction: onToggleAction
                )
                Divider()
            }
        }
    }

}

struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsListView(items: .constant([
            LogItemInfo(fileName: "", content: "")
        ]))
    }
}
