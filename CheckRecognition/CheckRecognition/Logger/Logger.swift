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

    private enum LogLevel {
        case Info
        case Debug
        case Warning
        case Error
    }
    
    private class func logLevelName(level: LogLevel) -> String {
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
    
    private class func releaseLogLevel() -> LogLevel {
        return .Error;
    }
    
    private class func logLevelAllowed(level: LogLevel) -> Bool {
        #if DEBUG
            return true
        #else
            return level == releaseLogLevel();
        #endif
    }
   
    private class func log(level: LogLevel, message: String, file: String, function: String, line: Int) {
        println("\(logLevelName(level)): \(file.lastPathComponent): \(function)[\(line)]: \(message)")
    }
    
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
