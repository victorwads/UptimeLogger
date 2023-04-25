//
//  AppDelegate.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let allowedMenus: [String] = [
        //Strings.menuLogs.value
    ]
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        UserDefaults.standard.register(
          defaults: ["NSApplicationCrashOnExceptions" : true]
        )
    }
    
    func applicationWillUpdate(_ notification: Notification) {
        if let menus = NSApplication.shared.mainMenu {
            if(menus.items.count < (allowedMenus.count + 1)){
                return
            }
            menus.items.enumerated().forEach { (index, menu) in
                if(index != 0 && !allowedMenus.contains(menu.title)){
                    menus.removeItem(menu);
                }
            }
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
