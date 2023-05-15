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
            let storedItem = EntityLogs(context: context)
            storedItem.id = logItem.id
            storedItem.fileName = logItem.fileName
            storedItem.version = Int16(logItem.version)
            storedItem.edited = logItem.edited
            storedItem.shutdownAllowed = logItem.shutdownAllowed
            storedItem.scriptStartTime = logItem.scriptStartTime
            storedItem.scriptEndTime = logItem.scriptEndTime
            storedItem.logProcessInterval = Int16(logItem.logProcessInterval)
            storedItem.systemVersion = logItem.systemVersion
            storedItem.systemBootTime = logItem.systemBootTime
            storedItem.systemUptime = logItem.systemUptime.let { NSNumber(value: $0) }
            storedItem.systemActivetime = logItem.systemActivetime.let { NSNumber(value: $0) }
            storedItem.batery = logItem.battery.let { NSNumber(value: $0) }
            storedItem.charging = logItem.charging.let { NSNumber(value: $0) }
            
            // Salvar processLogs associados
            for suspension in logItem.suspensions {
                let storedSuspension = EntityLogSuspensions(context: context)
                storedSuspension.logID = storedItem.id
                storedSuspension.count = Int64(suspension.value)
                storedSuspension.date = suspension.key
            }
            for state in logItem.suspensions {
                let storedState = EntityLogBatteryLevel(context: context)
                storedState.logID = storedItem.id
                storedState.level = Int64(state.value)
                storedState.date = state.key
            }
            for processLog in processLogs {
                let storedProcess = EntityLogProcesses(context: context)
                storedProcess.logID = storedItem.id
                storedProcess.user = processLog.user
                storedProcess.pid = Int64(processLog.pid)
                storedProcess.cpu = processLog.cpu
                storedProcess.mem = processLog.mem
                storedProcess.started = processLog.started
                storedProcess.time = processLog.time
                storedProcess.command = processLog.command
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
        let request: NSFetchRequest<EntityLogs> = EntityLogs.fetchRequest()
        request.predicate = NSPredicate(format: "fileName == %@", fileName as CVarArg)
        
        guard let logItemEntities = try? context.fetch(EntityLogs.fetchRequest())
        else { return nil }
        return logItemEntities
            .map { logItemEntity in LogItemInfo(entity: logItemEntity) }
            .filterNonNil()
            .first
    }
    
    func fetchAllLogItems() -> [LogItemInfo] {
        guard let logItemEntities = try? context.fetch(EntityLogs.fetchRequest())
        else { return [] }
        return logItemEntities
            .map { logItemEntity in LogItemInfo(entity: logItemEntity) }
            .filterNonNil()
    }
    
    func fetchProcess(for logItem: LogItemInfo) -> [ProcessLogInfo] {
        let request: NSFetchRequest<EntityLogProcesses> = EntityLogProcesses.fetchRequest()
        request.predicate = NSPredicate(format: "logID == %@", logItem.id as CVarArg)
        guard let processLogEntities = try? context.fetch(request)
        else { return [] }
        return processLogEntities
            .map { processLogEntity in ProcessLogInfo(entity: processLogEntity) }
            .filterNonNil()
    }
    
    func fetchDetails(for logItem: LogItemInfo) -> LogItemInfo {
        var logItem = logItem
        let predicate = NSPredicate(format: "logID == %@", logItem.id as CVarArg)
        
        let requestSuspensions: NSFetchRequest<EntityLogSuspensions> = EntityLogSuspensions.fetchRequest()
        requestSuspensions.predicate = predicate
        for suspension in ((try? context.fetch(requestSuspensions)) ?? []) {
            if let date = suspension.date {
                logItem.suspensions[date] = Int(suspension.count)
            }
        }

        let request: NSFetchRequest<EntityLogBatteryLevel> = EntityLogBatteryLevel.fetchRequest()
        request.predicate = NSPredicate(format: "logID == %@", logItem.id as CVarArg)

        for state in ((try? context.fetch(request)) ?? []) {
            if let date = state.date {
                logItem.batteryHistory[date] = Int(state.level)
            }
        }

        return logItem
    }
}

extension LogItemInfo {
    init?(entity: EntityLogs) {
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
        battery = entity.batery.let { Int(truncating: $0) }
        charging = entity.charging.let { $0 == 1 }

        logProcessInterval = Int(entity.logProcessInterval)
        hasProcess = logProcessInterval > 0
    }
}

extension ProcessLogInfo {
    init?(entity: EntityLogProcesses) {
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
