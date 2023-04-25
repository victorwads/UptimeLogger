//
//  DownloadProvider.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 20/04/23.
//

import Foundation

class DownloadProvider: NSObject, URLSessionDownloadDelegate {
    
    private let manager = FileManager.default
    private var supportFolder: URL {
        manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
    private let downloadURL: URL
    private let onComplete: (URL?, Error?) -> Void
    private let onProgress: (Double) -> Void

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
    
    public var destinationURL: URL {
        supportFolder.appendingPathComponent(downloadURL.lastPathComponent)
    }
    
    public var isDownloaded: Bool {
        FileManager.default.fileExists(atPath: destinationURL.path)
    }
    
    func download() {
        if(isDownloaded){
            return onComplete(destinationURL, nil)
        }

        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: downloadURL)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            if(!manager.fileExists(atPath: supportFolder.path)) {
                try manager.createDirectory(at: supportFolder, withIntermediateDirectories: true)
            }
            
            try FileManager.default.moveItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                self.onComplete(self.destinationURL, nil)
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
