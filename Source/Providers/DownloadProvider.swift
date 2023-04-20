//
//  DownloadProvider.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 20/04/23.
//

import Foundation

class DownloadProvider: NSObject, URLSessionDownloadDelegate {
    
    let downloadURL: URL
    let onComplete: (URL?, Error?) -> Void
    let onProgress: (Double) -> Void

    init?(
        _ stringUrl: String,
        onComplete: @escaping (URL?, Error?) -> Void,
        _ onProgress: @escaping (Double) -> Void
    ) {
        guard let url = URL(string: stringUrl) else { return nil }
        
        downloadURL = url
        self.onComplete = onComplete
        self.onProgress = onProgress
    }
    
    func download() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: downloadURL)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let destinationURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent(downloadURL.lastPathComponent) else {
            print("Error getting destination URL")
            return
        }
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.onComplete(destinationURL, nil)
            }
        } catch {
            DispatchQueue.main.async {
                self.onComplete(nil, error)
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.onProgress(progress)
        }
    }
    
}
