import CoreData

class LogsProviderWithCoreData {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveLogItem(_ logItem: LogItemInfo, processLogs: [ProcessLogInfo]) -> Bool {
        var ok = true
        context.performAndWait {
            // Criar e configurar o objeto LogItemEntity
            let logItemEntity = LogItemEntity(context: context)
            logItemEntity.id = logItem.id
            logItemEntity.fileName = logItem.fileName
            logItemEntity.version = Int16(logItem.version)
            logItemEntity.edited = logItem.edited
            logItemEntity.shutdownAllowed = logItem.shutdownAllowed
            logItemEntity.scriptStartTime = logItem.scriptStartTime
            logItemEntity.scriptEndTime = logItem.scriptEndTime
            logItemEntity.logProcessInterval = Int16(logItem.logProcessInterval)
            logItemEntity.systemVersion = logItem.systemVersion
            logItemEntity.systemBootTime = logItem.systemBootTime
            logItemEntity.systemUptime = logItem.systemUptime.let { NSNumber(value: $0) }
            logItemEntity.systemActivetime = logItem.systemActivetime.let { NSNumber(value: $0) }
            logItemEntity.batery = logItem.batery.let { NSNumber(value: $0) }
            logItemEntity.charging = logItem.charging.let { NSNumber(value: $0) }
    
            // Salvar processLogs associados
            for processLog in processLogs {
                let processLogEntity = ProcessLogEntity(context: context)
                processLogEntity.logID = logItemEntity.id
                processLogEntity.user = processLog.user
                processLogEntity.pid = Int64(processLog.pid)
                processLogEntity.cpu = processLog.cpu
                processLogEntity.mem = processLog.mem
                processLogEntity.started = processLog.started
                processLogEntity.time = processLog.time
                processLogEntity.command = processLog.command
            }
            do {
                try context.save()
            } catch {
                print("error \(error.localizedDescription), \(error)")
                ok = false
            }
        }
        return ok
    }
    
    func fetchLog(fileName: String) -> LogItemInfo? {
        let request: NSFetchRequest<LogItemEntity> = LogItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "fileName == %@", fileName as CVarArg)

        guard let logItemEntities = try? context.fetch(LogItemEntity.fetchRequest())
        else { return nil }
        return logItemEntities
            .map { logItemEntity in LogItemInfo(entity: logItemEntity) }
            .filterNonNil()
            .first
    }

    func fetchAllLogItems() -> [LogItemInfo] {
        guard let logItemEntities = try? context.fetch(LogItemEntity.fetchRequest())
        else { return [] }
        return logItemEntities
            .map { logItemEntity in LogItemInfo(entity: logItemEntity) }
            .filterNonNil()
    }

    func fetchProcessLogs(for logItem: LogItemInfo) -> [ProcessLogInfo] {
        let request: NSFetchRequest<ProcessLogEntity> = ProcessLogEntity.fetchRequest()
        request.predicate = NSPredicate(format: "logID == %@", logItem.id as CVarArg)
        guard let processLogEntities = try? context.fetch(request)
        else { return [] }
        return processLogEntities
            .map { processLogEntity in ProcessLogInfo(entity: processLogEntity) }
            .filterNonNil()
    }
}

extension LogItemInfo {
    init?(entity: LogItemEntity) {
        guard
            let _id = entity.id,
            let _fileName = entity.fileName,
            let _scriptStartTime = entity.scriptStartTime
        else { return nil }
        id = _id
        fileName = _fileName
        version = Int(entity.version)
        scriptStartTime = _scriptStartTime
        scriptEndTime = entity.scriptEndTime

        edited = entity.edited
        shutdownAllowed = entity.shutdownAllowed

        systemVersion = entity.systemVersion 
        systemBootTime = entity.systemBootTime
        systemUptime = entity.systemUptime.let { TimeInterval(truncating: $0) }
        systemActivetime = entity.systemActivetime.let { TimeInterval(truncating: $0) }
        batery = entity.batery.let { Int(truncating: $0) }
        charging = entity.charging.let { $0 == 1 }

        logProcessInterval = Int(entity.logProcessInterval)
        hasProcess = logProcessInterval > 0
        suspensions = [:]
    }
}

extension ProcessLogInfo {
    init?(entity: ProcessLogEntity) {
        guard 
            let _user = entity.user,
            let _started = entity.started,
            let _time = entity.time,
            let _command = entity.command
        else { return nil }
        user = _user
        started = _started
        time = _time
        command = _command
        pid = Int(entity.pid)
        cpu = entity.cpu
        mem = entity.mem
    }
}
