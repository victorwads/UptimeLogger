//
//  LogItemView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct LogItemView: View {
    
    @Binding var log: LogItemInfo
    var onToggleAction: ((LogItemInfo) -> Void)? = nil
    
    private var allow: Bool {
        get { log.shutdownAllowed }
    }
    
    var stack: some View {
        HStack(alignment: .center, spacing: 4) {
            let info = (!allow ? Strings.logUnexpectedYes.value : Strings.logUnexpectedNo.value) + log.formattedEndtime
            Text(info)
                .foregroundColor(allow ? .green : .red)
            Image(systemName: allow ? "checkmark.seal.fill" : "bolt.trianglebadge.exclamationmark.fill")
                .font(.headline)
                .foregroundColor(allow ? .green : .red)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading){
                HStack(alignment: .center) {
                    Image(systemName: "power")
                    Text(Strings.logStartup.value).bold()
                    Text(log.formattedStartUptime)
                        .font(.subheadline)
                }.padding(.bottom, 2)
                HStack(alignment: .center) {
                    Image(systemName: "bolt.badge.clock.fill")
                    Text(Strings.logUptime.value).bold()
                    Text(log.formattedUptime)
                        .font(.subheadline)
                }
            }
            Spacer()
            Text(Strings.logUnexpected.value).bold()
                .font(.subheadline)
                .foregroundColor(.gray)

            if let onToggleAction = onToggleAction {
                stack.onTapGesture {
                    onToggleAction(log)
                }.help(Strings.logHelp.value)
                Divider()
                Text("v\(log.version)")
                    .foregroundColor(.gray)
            } else {
                stack
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
