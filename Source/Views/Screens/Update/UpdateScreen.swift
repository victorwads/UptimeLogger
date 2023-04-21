//
//  UpdateScreen.swift
//  UptimeLogger
//
//  Created by Victor Wads on 20/04/23.
//

import SwiftUI

struct UpdateScreen: View {
    let currentVersionName: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    @State private var downloadURL: String = ""
    @State private var downloadProgress: Double? = nil
    @State private var updateAvailable: Bool? = nil
    @State private var releaseInfo: GitHubRelease? = nil

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Label("Atualizações", systemImage: "arrow.clockwise")
                        .font(.title)
                        .padding()
                    Spacer()
                    Text("A versão atual é: \(currentVersionName)")
                        .font(.footnote)
                        .padding()
                }
            }
            Divider()
                .padding(.bottom, 40)
            if updateAvailable == nil {
                Spacer()
                ProgressView()
            } else if let release = releaseInfo, updateAvailable ?? false {
                HStack {
                    Spacer()
                    Text("Update available!")
                        .font(.title2)
                    Spacer()
                    Button(action: download) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.title)
                        Text("Download v\(release.tag_name)")
                    }
                    .disabled(downloadProgress != nil)
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    Spacer()
                }
                if !release.body.isEmpty {
                    Text(release.body)
                        .font(.body)
                        .padding(25)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            } else {
                Text("No updates available")
                    .font(.title2)
                Text("last version \(releaseInfo?.tag_name ?? "")")
                    .font(.subheadline)
                    .padding()
            }
            if let downloadProgress = downloadProgress {
                HStack {
                    ProgressView(value: downloadProgress, total: 1)
                        .progressViewStyle(.linear)
                    Text(String(format: "%.2f%%", downloadProgress * 100))
                }.padding()
            }
            Spacer()
        }
        .onAppear {
            checkForUpdates()
        }
    }
    
    func checkForUpdates() {
        let url = URL(string: "https://api.github.com/repos/victorwads/UptimeLogger/releases/latest")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let release = try JSONDecoder().decode(GitHubRelease.self, from: data)
                if let asset = release.assets.first(where: { $0.name.hasSuffix(".dmg") }) {
                    DispatchQueue.main.async {
                        downloadURL = asset.browser_download_url
                        updateAvailable = release.tag_name.compareVersion(currentVersionName) == 1
                        releaseInfo = release
                    }
                } else {
                    updateAvailable = false
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func download() {
        DownloadProvider(
            downloadURL,
            onComplete: { url, error in
                guard let url = url else { return }
                initUpdate(url)
            }
        ){ progress in
            downloadProgress = progress
        }?.download()        
        downloadProgress = 0
    }
    
    func initUpdate(_ url: URL) {
        let alert = NSAlert()
        alert.messageText = "Download concluído"
        alert.informativeText = "O download foi concluído com sucesso. Clique em OK para abrir o arquivo baixado e fechar o programa."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Atualizar Agora")
        alert.addButton(withTitle: "Cancel")

        let modalResult = alert.runModal()
        if modalResult == .alertFirstButtonReturn {
            NSWorkspace.shared.open(url)
            NSApplication.shared.terminate(self)
        }
        downloadProgress = nil
    }
}

struct GitHubRelease: Codable {
    var assets: [GitHubAsset]
    var tag_name: String
    var body: String
}

struct GitHubAsset: Codable {
    var name: String
    var browser_download_url: String
}

struct UpdateScreen_Previews: PreviewProvider {
    static var previews: some View {
        UpdateScreen()
    }
}
