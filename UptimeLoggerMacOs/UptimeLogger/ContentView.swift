//
//  ContentView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 09/04/23.
//

import SwiftUI
import Foundation

func logsDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let logsDirectory = documentsDirectory.appending("/UptimeLogger/logs")
    return logsDirectory
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "clock.fill")
                    .font(.largeTitle)
                Text("Uptime Logger")
                    .font(.title)
                    .fontWeight(.bold)
                NavigationLink(destination: LogsView()) {
                    Text("View Logs")
                        .font(.headline)
                }
                Spacer()
                HStack {
                    Button(action: {}) {
                        Text("Install")
                            .font(.headline)
                    }
                    Button(action: {}) {
                        Text("Uninstall")
                            .font(.headline)
                    }
                    Button(action: {}) {
                        Text("Restart")
                            .font(.headline)
                    }
                }
            }
            .padding()
            //.navigationBarTitle(Text("Uptime Logger"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

