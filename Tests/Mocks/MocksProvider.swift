import Foundation
@testable import UptimeLogger

class MocksProvider {
    
    static func getLog(of file: String) -> LogItemInfo {
        guard let path = Bundle(for: self).resourceURL?.path else {
            return LogsProviderMock.empty
        }
        
        let provider = LogsProviderFilesSystem(folder: path)
        
        return provider.loadLogWith(filename: file)
    }

    static func getProcesses(of file: String) -> [ProcessLogInfo] {
        guard let path = Bundle(for: self).resourceURL?.path else {
            return []
        }
        
        let provider = LogsProviderFilesSystem(folder: path)
        
        return provider.loadProccessLogFor(filename: file)
    }

}
