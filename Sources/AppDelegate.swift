//
//  AppDelegate.swift
//  UptimeLogger
//
//  Created by Victor Wads on 10/04/23.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    static let name = "UptimeLogger"
    static let defaultFolder = "/Library/Application Support/" + name

    private let allowedMenus: [String] = [
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
    
    lazy var persistentContainer: NSPersistentContainer = {
        // Criar a URL para o diretório de Application Support do macOS
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .localDomainMask).first!
        let appDir = appSupportDir.appendingPathComponent(AppDelegate.name)

        // Verificar se o diretório já existe e, se não, criar ele
        if !FileManager.default.fileExists(atPath: appDir.path) {
            try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true, attributes: nil)
        }

        // Criar a URL para o arquivo do banco de dados
        let dbURL = appDir.appendingPathComponent(AppDelegate.name + ".sqlite")


        let description = NSPersistentStoreDescription(url: dbURL)
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true

        let container = NSPersistentContainer(name: "LogsDataModel")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

}
