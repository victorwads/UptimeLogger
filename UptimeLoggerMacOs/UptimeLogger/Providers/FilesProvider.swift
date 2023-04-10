//
//  FileManager.swift
//
//  Created by Baye Wayly on 2019/9/23.
//  Copyright © 2019 Baye. All rights reserved.
//
import Cocoa
import Foundation

func bookmarkKey(_ path: String) -> String{
//  return "bm:\(path.hasSuffix("/") ? path : path + "/")"
  return "bm2:\(path)"
}

func bookmarkKey(url: URL) -> String{
  return bookmarkKey(url.path)
}

class FilesProvider {
  public static let shared = FilesProvider()
  
  func authorize(_ path: String, callback: @escaping (String) -> Void){
    if let bookmarkData = UserDefaults.standard.object(forKey: bookmarkKey(path)){
      if self.resolveBookmark(data: bookmarkData as! Data){
        callback(path)
        return
      }
    }
    
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = false
    openPanel.directoryURL = URL(fileURLWithPath: path)
    openPanel.message = "No permission to access logs folder\nTo allow access, select the logs folder"
    openPanel.showsHiddenFiles = true
    openPanel.begin { (result) -> Void in
      if result == NSApplication.ModalResponse.OK {
        let url = openPanel.urls.first!
        print("selected url", url, url.path)
        do{
          let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
          UserDefaults.standard.setValue(bookmarkData, forKey: bookmarkKey(url: url))
          _ = self.resolveBookmark(data: bookmarkData)
          callback(url.path)
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  func resolveBookmark(data: Data) -> Bool{
    do{
      var isStale = ObjCBool(false)
      let url = try NSURL(resolvingBookmarkData: data, options: URL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
      
      print("resolved url \(url)")
      
      if isStale.boolValue{
        print("renew bookmark data")
        let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.setValue(bookmark, forKey:bookmarkKey(url.path!))
      }
      
      if !url.startAccessingSecurityScopedResource(){
          print("Failed to access sandbox files")
      }
      
      print("Started accessing")
      return true
      
    } catch {
        print(error.localizedDescription)
      return false
    }
  }

}
