//
//  Copyright (c) 2020 PayMaya Philippines, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

public enum LogLevel {
    /// Don't log anything
    case off
    
    /// Log only errors
    case error
    
    /// Log errors and informative messages
    case debug
    
    /// Log everything that's happening
    case all
}

class Log {
    enum LogType: String {
        case info = "ℹ️"
        case error = "⛔️"
        case verbose = "✏️"
    }
    
    static var logLevel: LogLevel = .off
    static var logger: Logger = PrintLogger()
    
    static func error(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        Log.log(message, type: .error, fileName: fileName, line: line, funcName: funcName)
        #endif
    }
    
    static func info(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        Log.log(message, type: .info, fileName: fileName, line: line, funcName: funcName)
        #endif
    }
    
    static func verbose(_ message: String, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        #if DEBUG
        Log.log(message, type: .verbose, fileName: fileName, line: line, funcName: funcName)
        #endif
    }
}

private extension Log {
    static var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }
    
    static func log(_ message: String, type: LogType, fileName: String = #file, line: Int = #line, funcName: String = #function) {
        guard logLevel != .off else { return }
        
        switch (logLevel, type) {
        case (.error, .error):
            fallthrough
        case (.debug, _):
            if type == .verbose { break } else { fallthrough }
        case (.all, _):
            logger.log("\(currentDate) \(type.rawValue) [\(sourceFileName(filePath: fileName)):\(line)] \(funcName) ‣ \(message)")
        default: break
        }
        
    }
    
    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        
        if let lastComponent = components.last {
            return lastComponent
        }
        return ""
    }
}
