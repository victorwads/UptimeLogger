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


    var ServiceInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
                    .font(.title)
                Text(Strings.installServiceTitle.value)
                    .font(.title)
                    .bold()
                Spacer()
                Image(systemName: "circle.fill")
                    .foregroundColor(isRunning ? .green : .red)
            }
            Text(Strings.installMessage.value)
        }.onAppear(perform: updateStatus)
    }
    
    var InstallView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
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
            TextEditor(text: $command)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .frame(height: 40)
            Text(Strings.installStep2.value)
            HStack {
                Spacer()
                if(isRunning){
                    Button("Desinstalar", action: { sendComand(InstallationView.deleteComand) })
                    Button("Atualizar", action: { sendComand(InstallationView.updateComand) })
                }
                Button("Continuar", action: continueInstall)
            }
        }
    }
    
    var body: some View {
        VStack() {
            ServiceInfoView.padding(.bottom, 20)
            Divider().padding(.bottom, 60)
            InstallView
            Spacer()
        }
        .padding()
    }
    
    private func updateStatus(){
        isRunning = provider.isServiceInstalled
    }

    private func sendComand(_ command: String){
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(command, forType: .string)
        provider.installService()
    }

    private func continueInstall() {
        updateStatus()
        if (!provider.isServiceInstalled) {
            sendComand(InstallationView.installComand)
        } else {
            navigateToLogs()
        }
    }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(
            provider: LogsProvider(),
            navigateToLogs: {}
        )
    }
}
