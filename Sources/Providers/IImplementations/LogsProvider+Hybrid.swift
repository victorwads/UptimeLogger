import CoreData

class LogsProviderHybrid: LogsProvider {

    let withFiles: LogsProviderFilesSystem
    let withCoreData: LogsProviderWithCoreData

    init(folder: String = AppDelegate.defaultFolder, _ container: NSPersistentContainer) {
        _ = FilesProvider.shared.isAutorized(folder)
        self.withFiles = LogsProviderFilesSystem(folder: folder)
        self.withCoreData = LogsProviderWithCoreData(context: container.viewContext)
    }

    func convertToCoreData(_ logs: [LogItemInfo]) {
        for log in logs {
            if(withCoreData.saveLogItem(log, processLogs: withFiles.loadProccessLogFor(log: log))) {
                withFiles.removeLog(log.fileName)
            }
        }
    }

    var folder: String { withFiles.folder }
    var isReadable: Bool { true }
    var isWriteable: Bool { true }

    func setFolder(_ folder: String) { withFiles.setFolder(folder) }

    func loadLogs() -> [LogItemInfo] {
        convertToCoreData(withFiles.loadLogs())
        return withCoreData.fetchAllLogItems()
    }

    func loadCurrentLog() -> LogItemInfo {
        var log = withFiles.loadCurrentLog()
        log.current = true
        return log
    }

    func loadLogWith(filename: String?) -> LogItemInfo {
        guard let filename = filename else {
            return loadCurrentLog()
        }
        return withCoreData.fetchLog(fileName: filename) ?? LogsProviderMock.empty
    }
    
    func loadProccessLogFor(log: LogItemInfo) -> [ProcessLogInfo] {
        if (log.current) {
            return withFiles.loadProccessLogFor(log: log)
        }
        return withCoreData.fetchProcessLogs(for: log)
    }

    func toggleShutdownAllowed(_ log: LogItemInfo) {
        
    }
}
