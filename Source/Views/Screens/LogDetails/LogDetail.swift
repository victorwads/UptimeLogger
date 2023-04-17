//
//  LogDetail.swift
//  UptimeLogger
//
//  Created by Victor Wads on 17/04/23.
//

import SwiftUI

struct LogDetail: View {

    let provider: LogsProvider
    
    @State var logFile: LogItemInfo? = nil
    @State var test: String? = nil

    var body: some View {
        Text(test ?? "No link")
        .onOpenURL { url in
            loadLog(url.lastPathComponent)
        }
    }
    
    public func loadLog(_ fileName: String) {
        test = fileName
    }
}


struct LogDetail_Previews: PreviewProvider {
    let view = LogDetail(
        provider: LogsProvider()
    )
    
    static var previews: some View {
        LogDetail(
            provider: LogsProvider()
        )
    }
}
