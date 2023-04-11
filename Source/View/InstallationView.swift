//
//  InstallationView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

struct InstallationView: View {

    @Binding var currentFolder: String

    let onContinue: () -> Void
    private let installComand = "./install"
    
    var ServiceInfoView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "bolt.trianglebadge.exclamationmark.fill")
                    .font(.title)
                Text(Strings.installServiceTitle.value)
                    .font(.title)
                    .bold()
            }
            Text(Strings.installMessage.value)
            Text(currentFolder)
                .font(.subheadline)
                .foregroundColor(.gray)

        }
    }
    
    var InstallView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
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
            TextEditor(text: .constant(installComand))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
                .background(Color(NSColor.textBackgroundColor))
                .cornerRadius(8)
                .frame(height: 40)
            Text(Strings.installStep2.value)
        }
    }

    var body: some View {
            VStack() {
                ServiceInfoView
                InstallView.padding(.top, 60)
                Spacer()
                HStack {
                    Spacer()
                    Button("Continuar", action: onContinue)
                }
            }
            .padding()
            .onAppear {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(installComand, forType: .string)
            }
        }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(
            currentFolder: .constant(""),
            onContinue: {}
        )
    }
}
