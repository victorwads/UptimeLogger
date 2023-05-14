//
//  CoreDataProviderTest.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 03/05/23.
//

import XCTest
import CoreData

@testable import UptimeLogger

class CoreDataLogProviderTests: XCTestCase {

    var coreDataLogProvider: LogsProviderWithCoreData!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        // Configura o modelo CoreData
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        // Cria um objeto de persistência baseado em memória para os testes
        persistentContainer = NSPersistentContainer(name: "YourAppName", managedObjectModel: managedObjectModel)
        persistentContainer.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.persistentStoreDescriptions[0].type = NSInMemoryStoreType

        // Adiciona o objeto de persistência ao coordenador de persistência
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)

        // Cria um contexto de objeto gerenciado
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        // Cria o provedor de dados do CoreData
        coreDataLogProvider = LogsProviderWithCoreData(context: managedObjectContext)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSaveAndFetchLogItem() {
        let fileName = "log_2023-04-17_00-13-40.txt"
        let logItem = MocksProvider.getLog(of: fileName)

        // Salva o objeto LogItemInfo no CoreData
        coreDataLogProvider.saveLogItem(logItem, processLogs: [])

        // Recupera todos os objetos LogItemInfo do CoreData
        let logItems = coreDataLogProvider.fetchAllLogItems()

        // Verifica se o objeto salvo está presente na lista
        XCTAssertEqual(logItems.count, 1)
        XCTAssertEqual(logItems[0].fileName, fileName)
        XCTAssertEqual(logItems[0].version, 4)
        XCTAssertEqual(logItems[0].edited, false)
        XCTAssertEqual(logItems[0].shutdownAllowed, false)
        XCTAssertEqual(logItems[0].logProcessInterval, 2)
        XCTAssertEqual(logItems[0].systemVersion, "13.4")
        XCTAssertEqual(logItems[0].batery, 72)
        XCTAssertEqual(logItems[0].charging, false)
    }
    
    func testSaveAndFetchLogItemProccess() {
        let logItem = LogItemInfo("log_2023-04-17_00-13-40.txt")

        // Salva o objeto LogItemInfo no CoreData
        coreDataLogProvider.saveLogItem(logItem, processLogs: MocksProvider.getProcesses(of: logItem))

        // Recupera todos os objetos LogItemInfo do CoreData
        let logItems = coreDataLogProvider.fetchAllLogItems()
        let processesItems = coreDataLogProvider.fetchProcess(for: logItems[0])

        // Verifica se o objeto salvo está presente na lista
        XCTAssertEqual(processesItems.count, 12)
    }
}
