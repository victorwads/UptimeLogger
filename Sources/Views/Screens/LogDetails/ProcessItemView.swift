//
//  ProccesView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 19/04/23.
//

import SwiftUI

struct ProccesView: View {
    
    let process: ProcessLogInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                Text(process.user)
                Image(systemName: "number")
                Text(String(process.pid))
                Text(String(format: "%.1f%% CPU", process.cpu))
                    .foregroundColor(.green)
                Text(String(format: "%.1f%% MEM", process.mem))
                    .foregroundColor(.blue)
                Text(process.started)
                Text(process.time)
            }
            .font(.caption)
            Text(process.command)
        }
        Divider()
    }
}

struct ProccesView_Previews: PreviewProvider {
    static var previews: some View {
        ProccesView(
            process: ProcessLogInfo("victorwads       46730   1,6  0,0  4:59     0:04.57 -zsh")!
        )
    }
}
