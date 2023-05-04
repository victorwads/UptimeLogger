import CoreData

class CoreDataLogProvider {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveLogItem(_ logItem: LogItemInfo, processLogs: [ProcessLogInfo]) {
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
            processLogEntity.id = processLog.id
            processLogEntity.user = processLog.user
            processLogEntity.pid = Int64(processLog.pid)
            processLogEntity.cpu = processLog.cpu
            processLogEntity.mem = processLog.mem
            processLogEntity.started = processLog.started
            processLogEntity.time = processLog.time
            processLogEntity.command = processLog.command

            logItemEntity.id.let { processLogEntity.idLog = $0 }
            logItemEntity.addToProcessLogEntities(processLogEntity)
        }
        
        // Salvar as alterações no contexto
        do { try context.save() }
        catch { print("Erro ao salvar LogItemInfo e ProcessLogInfo: \(error)") }
    }
    
    func fetchAllLogItems() -> [LogItemInfo] {
        do {
            let logItemEntities = try context.fetch(LogItemEntity.fetchRequest())
            return logItemEntities
                .map { logItemEntity in LogItemInfo(entity: logItemEntity) }
                .filterNonNil()
        } catch { return [] }
    }

    func fetchProcessLogs(for logItem: LogItemInfo) -> [ProcessLogInfo] {
        let request: NSFetchRequest<ProcessLogEntity> = ProcessLogEntity.fetchRequest()
        request.predicate = NSPredicate(format: "idLog == %@", logItem.id as CVarArg)

        do {
            let processLogEntities = try context.fetch(request)
            return processLogEntities
                .map { processLogEntity in ProcessLogInfo(entity: processLogEntity) }
                .filterNonNil()
        } catch { return [] }
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
    }
}

extension ProcessLogInfo {
    init?(entity: ProcessLogEntity) {
        guard 
            let _id = entity.id,
            let _user = entity.user,
            let _started = entity.started,
            let _time = entity.time,
            let _command = entity.command
        else { return nil }
        id = _id
        user = _user
        started = _started
        time = _time
        command = _command
        pid = Int(entity.pid)
        cpu = entity.cpu
        mem = entity.mem
    }
}
