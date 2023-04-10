//
//  ContentView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @Binding var logs: [LogItemInfo]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Logs")
                .font(.title)
                .foregroundColor(.gray)
            
            LogsView(items: $logs)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(logs: .constant([]))
    }
}

