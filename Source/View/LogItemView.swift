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
        HStack(alignment: .center) {
            Image(systemName: allow ? "powersleep" : "bolt.slash.fill")
                .foregroundColor(allow ? .green : .red)
            Text(!allow ? Strings.logUnexpectedYes.value : Strings.logUnexpectedNo.value)
                .foregroundColor(allow ? .green : .red)
        }
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading){
                HStack(alignment: .center) {
                    Image(systemName: "power")
                    Text(Strings.logStartup.value).bold()
                    Text("\(log.formattedStartUptime)")
                }
                HStack(alignment: .center) {
                    Image(systemName: "clock")
                    Text(Strings.logUptime.value).bold()
                    Text("\(log.formattedUptime)")
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
