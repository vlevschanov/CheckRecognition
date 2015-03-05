//
//  Logger.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 11/25/14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

@objc
class Logger {

    private enum Level {
        case Info
        case Debug
        case Warning
        case Error
    }
    
    struct Static {
        static let dateFormatter = Logger.initFormatter()
    }
    
    private class func initFormatter() -> NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        return formatter
    }
    
    private class func logLevelName(level: Level) -> String {
        switch(level) {
        case .Info:
            return "INFO"
        case .Debug:
            return "DEBUG"
        case .Warning:
            return "WARNING"
        case .Error:
            return "ERROR"
        }
    }
    
    private class func releaseLogLevel() -> Level {
        return .Error;
    }
    
    private class func logLevelAllowed(level: Level) -> Bool {
        #if DEBUG
            return true
        #else
            return level == releaseLogLevel();
        #endif
    }
   
    private class func log<T>(level: Level, message: T, file: String, function: String, line: Int) {
        println("\(Static.dateFormatter.stringFromDate(NSDate())): \(logLevelName(level)): \(file.lastPathComponent): \(function)[\(line)]: \(message)")
    }
    
    // MARK: - Swift Log methods
    
    class func debug<T>(message: T, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Debug, message: message, file: file, function: function, line: line);
    }
    
    class func info<T>(message: T, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Info, message: message, file: file, function: function, line: line);
    }
    
    class func warning<T>(message: T, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Warning, message: message, file: file, function: function, line: line);
    }
    
    class func error<T>(message: T, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__)  {
        log(.Error, message: message, file: file, function: function, line: line);
    }
    
    // MARK: - Obj-C Log methods
    
    class func logD(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Debug, message: message, file: file, function: function, line: line);
    }
    
    class func logI(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Info, message: message, file: file, function: function, line: line);
    }
    
    class func logW(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        log(.Warning, message: message, file: file, function: function, line: line);
    }
    
    class func logE(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__)  {
        log(.Error, message: message, file: file, function: function, line: line);
    }
}
