//
//  InstallationView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

struct InstallationView: View {
    
    static private let installComand = "./install"
    static private let updateComand = "./install --update"
    static private let deleteComand = "./install --uninstall"

    let provider: LogsProvider
    let navigateToLogs: () -> Void
    
    @State var isRunning: Bool = false
    @State var command: String = InstallationView.installComand
    @State var current: LogItemInfo = LogItemInfo()

    private let wrapper = TimerWrapper()

    var ServiceInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                Text(Strings.installServiceTitle.value)
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "circle.fill")
                    .foregroundColor(isRunning ? .green : .red)
            }
            Text(Strings.installMessage.value)
            
            if (isRunning) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(Strings.mainCurrentInfo.value)
                        .font(.subheadline)
                    Divider()
                    LogItemView(
                        log: $current
                    )
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                    Divider()
                }.padding(.top, 20)
                .onAppear(perform: self.initLogs)
                .onDisappear(perform: {
                    wrapper.timer?.invalidate()
                    wrapper.timer = nil
                })
            }
        }.onAppear(perform: updateStatus)
    }
    
    var InstallView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                        .foregroundColor(.accentColor)
                    Text(Strings.installTitle.value)
                        .font(.title)
                        .bold()
                }
                Spacer()
                Image(systemName: "info.circle").foregroundColor(.gray)
                Text(Strings.installStep1Tip.value)
                    .foregroundColor(.gray)
            }
            Text(Strings.installStep1.value)
            
            HStack(spacing: 0) {
                TextEditor(text: $command)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.primary)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(8)
                    .frame(height: 20)
            }
            Text(Strings.installStep2.value)
            HStack {
                Spacer()
                Button("Continuar", action: continueInstall)
            }
        }
    }
    
    var body: some View {
        VStack() {
            ServiceInfoView.padding(.bottom, 40)
            InstallView
            Spacer()
        }
        .padding()
    }
    
    private func initLogs(){
        wrapper.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            updateStatus()
        }
        wrapper.timer?.fire()
    }

    private func updateStatus(){
        current = provider.loadCurrentLog()
        isRunning = true
    }

    private func continueInstall() {
        updateStatus()
        navigateToLogs()
    }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(
            provider: LogsProvider(),
            navigateToLogs: {}
        ).environment(\.locale, .english)
        InstallationView(
            provider: LogsProvider(),
            navigateToLogs: {}
        ).environment(\.locale, .portuguese)
    }
}
