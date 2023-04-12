//
//  LogsListScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 11/04/23.
//

import SwiftUI

class TimerWrapper {
    public var timer: Timer?
}

struct LogsListScreen: View {

    @State private var serviceInstalled: Bool = false
    @State private var showInstallation: Bool = false
    @State private var logs: [LogItemInfo]? = nil
    @State private var currentLog: LogItemInfo = LogItemInfo()
    @State private var foldersHistory: [String] = []

    @AppStorage("logsFolder") var logsFolder: String = LogsProvider.shared.folder
    @AppStorage("foldersHistory") var logsFolderHistory: String = ""
    
    let provider: LogsProvider

    private let wrapper = TimerWrapper()

    var body: some View {
            VStack {
                if(showInstallation){
                    InstallationView(
                        currentFolder: $logsFolder,
                        onContinue: continueInstall
                    )
                } else {
                    ContentView(
                        logs: $logs,
                        logsFolder: $logsFolder,
                        current: $currentLog,
                        toggleItemAction: {item in
                            provider.toggleShutdownAllowed(item)
                            loadLogs()
                        }
                    )
                    LegendView()
                }
            }.onAppear(perform: self.initLogs)
            .onDisappear(perform: {
                wrapper.timer?.invalidate()
                wrapper.timer = nil
            })
    }
    
    private func initLogs(){
        foldersHistory = logsFolderHistory.components(separatedBy: ",").filter { !$0.isEmpty }
        provider.folder = logsFolder
        changeFolder(false)
        
        serviceInstalled = provider.isServiceInstalled
        
        wrapper.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            loadCurrent()
        }
        wrapper.timer?.fire()
    }
    
    private func updateRecents() {
        let path = provider.folder
        if !foldersHistory.contains(path) {
            foldersHistory.append(path)
            logsFolderHistory = foldersHistory.joined(separator: ",")
        }
    }
    
    private func changeFolder(_ change: Bool = true, _ folder: String? = nil) {
        let folder = folder ?? LogsProvider.shared.folder
        FilesProvider.shared.authorize(folder, change) {
            provider.folder = $0
            logsFolder = $0
            loadLogs()
            updateRecents()
        }
    }
    
    private func loadCurrent() {
        var current = provider.loadCurrentLog()
        currentLog = current
    }

    private func loadLogs() {
        logs = nil
        loadCurrent()
        DispatchQueue.global().async {
            logs = provider.loadLogs()
            
            if(!serviceInstalled && logs?.count ?? 0 < 1) {
                showInstallation = true
            } else {
                showInstallation = false
            }
        }
    }
    
    private func continueInstall() {
        if (!provider.isServiceInstalled) {
            provider.installService()
        } else {
            showInstallation=false
        }
    }
}

struct LogsListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogsListScreen(
            provider: LogsProvider.shared
        )
    }
}
