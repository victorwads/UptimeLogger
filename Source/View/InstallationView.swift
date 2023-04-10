//
//  InstallationView.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

struct InstallationView: View {

    let onContinue: () -> Void
    private let installComand = "./install"

    var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text(Strings.installServiceTitle.value)
                    .font(.title)
                    .bold()
                Text(Strings.installMessage.value)
                
                Spacer()
                
                Divider()
                HStack {
                    Text(Strings.installTitle.value)
                        .font(.title)
                        .bold()
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
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button("Continuar", action: onContinue)
                }
            }
            .padding(40)
            .onAppear {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(installComand, forType: .string)
            }
        }
}

struct InstallationView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationView(onContinue: {})
    }
}
