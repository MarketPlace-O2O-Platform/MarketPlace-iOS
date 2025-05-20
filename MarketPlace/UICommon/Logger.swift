import os.log

struct Logger {
    private static let logger = Logger()
    
    // 로그 레벨 정의
    enum LogLevel {
        case info, debug, error
    }
    
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, line: Int = #line) {
        let logMessage = "[\(file):\(line)] \(message)"
        
        switch level {
        case .info:
            os_log("%@", log: OSLog.default, type: .info, logMessage)
        case .debug:
            os_log("%@", log: OSLog.default, type: .debug, logMessage)
        case .error:
            os_log("%@", log: OSLog.default, type: .error, logMessage)
        }
    }
}
