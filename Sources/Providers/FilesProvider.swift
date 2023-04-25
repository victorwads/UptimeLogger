//
//  FileManager.swift
//
//  Created by Baye Wayly on 2019/9/23.
//  Copyright © 2019 Baye. All rights reserved.
//
import Cocoa
import Foundation
import FirebaseCrashlytics

func bookmarkKey(_ path: String) -> String{
    return "bm2:\(path)"
}

class FilesProvider {
    public static let shared = FilesProvider()
    
    func isAutorized(_ path: String) -> Bool {
        if let bookmarkData = UserDefaults.standard.object(forKey: bookmarkKey(path)){
            if self.resolveBookmark(data: bookmarkData as! Data){
                return true
            }
        }
        return false
    }
    
    func authorize(_ path: String, _ change: Bool, callback: @escaping (String) -> Void){
        if !change && isAutorized(path) {
            callback(path)
            return
        }
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.directoryURL = URL(fileURLWithPath: path)
        openPanel.message = .localized(.providerFilesOpenMessage)
        openPanel.showsHiddenFiles = true
        openPanel.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK, let url = openPanel.urls.first {
                do{
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    UserDefaults.standard.setValue(bookmarkData, forKey:bookmarkKey(path))
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                callback(url.path)
            } else if (!change) {
                callback(path)
            }
        }
    }
    
    func resolveBookmark(data: Data) -> Bool{
        do{
            var isStale = ObjCBool(false)
            let url = try NSURL(resolvingBookmarkData: data, options: URL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            
            if isStale.boolValue{
                let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                if let path = url.path {
                    UserDefaults.standard.setValue(bookmark, forKey:bookmarkKey(path))
                }
            }
            
            guard url.startAccessingSecurityScopedResource() else {
                // Access was not granted, handle it here
                return false
            }
            
            return  FileManager.default.fileExists(atPath: url.path ?? "") &&
                    FileManager.default.isReadableFile(atPath: url.path ?? "")
        } catch {
            Crashlytics.crashlytics().record(error: error)
            return false
        }
    }
    
}
