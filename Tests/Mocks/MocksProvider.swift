import Foundation

class MocksProvider {
    
    static func getContent(of file: String) -> String {
        guard let path = Bundle(for: self).path(forResource: file, ofType: nil) else {
            return ""
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            return content
        } catch {
            print("Error reading file: \(error)")
            return ""
        }
    }
    
}
