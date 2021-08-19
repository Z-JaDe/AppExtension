//
//  Log.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 16/9/23.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import os.log

//private let dateFormat = "'当前时间: 'HH: mm: ss.SSS"
public protocol LogUploadProtocol {
    func logUpload(_ level: LogLevel, _ message: String)
}
public enum LogLevel: String, CaseIterable {
    case debug = "Debug"
    case warn = "Warn"
    case info = "Info"
    case error = "Error"
    var value: Int {
        switch self {
        case .debug: return 0
        case .warn: return 1
        case .info: return 2
        case .error: return 3
        }
    }
    var logType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warn: return .default
        case .error: return .error
        }
    }
    var `public`: Bool {
        switch self {
        case .debug: return false
        case .info: return true
        case .warn: return true
        case .error: return true
        }
    }
    var iconStr: String {
        switch self {
        case .debug: return "🚑"
        case .info: return "ℹ️"
        case .warn: return "⚠️"
        case .error: return "❌"
        }
    }
}
public struct Logger {
    public let module: String
    public init(_ module: String) {
        self.module = module
    }
    public static let `default`: Logger = Logger("default")
    public static var logLevels: [LogLevel]?
    private let tag: String = jd.appDisplayName ?? "未知App名称"
//    private let timeFormatter: DateFormatter = {
//        let result = DateFormatter()
//        result.dateFormat = dateFormat
//        return result
//    }()
    private func logMessage(_ level: LogLevel, _ title: String) -> String {
        var str: String = "\(level.iconStr) "
        str.append("\(tag)(\(level.rawValue)) ")
//        str.append("🕒\(timeFormatter.string(from: Date())), ")
        str.append("module: \(module), ")
        str.append(title)
        return str
    }

    fileprivate func log(level: LogLevel, title: String, message: @escaping @autoclosure () -> String) {
        if let logLevels = Logger.logLevels, logLevels.contains(level) == false {
            return
        }
        if let logger = self as? LogUploadProtocol {
            logger.logUpload(level, "\(title), \(message())")
        }
        #if DEBUG
        let prefixMessage = logMessage(level, title)
        if #available(iOS 14.0, *) {
            if level.public {
                os_log(level.logType, log: .default, "\(prefixMessage, privacy: .public) - \(message(), privacy: .public)")
            } else {
                os_log(level.logType, log: .default, "\(prefixMessage, privacy: .public) - \(message(), privacy: .private)")
            }
        } else {
            if level.public {
                os_log(level.logType, "%{public}s - %{public}s", prefixMessage, message())
            } else {
                os_log(level.logType, "%{public}s - %{private}s", prefixMessage, message())
            }
        }
        #endif
    }
}
public func logTimer(_ closure: () -> Void) {
    #if DEBUG
    logDebug("开始计时")
    let date = Date().timeIntervalSince1970
    closure()
    logDebug("结束计时\(date - Date().timeIntervalSince1970)")
    #else
    closure()
    #endif
}
// MARK: - 在 Relase 模式下，关闭后台打印
public func logDebug(_ logger: Logger, _ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logger.log(level: .debug, title: title, message: message())
}
public func logInfo(_ logger: Logger, _ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logger.log(level: .info, title: title, message: message())
}
public func logWarn(_ logger: Logger, _ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logger.log(level: .warn, title: title, message: message())
}
public func logError(_ logger: Logger, _ title: String, _ message: @escaping @autoclosure () -> String = "", file: String = #file, method: String = #function, line: UInt = #line) {
    logger.log(level: .error, title: title, message: "\(file)[\(line)], \(method): \(message())")
}

public func logDebug(_ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logDebug(.default, title, message())
}
public func logInfo(_ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logInfo(.default, title, message())
}
public func logWarn(_ title: String, _ message: @escaping @autoclosure () -> String = "") {
    logWarn(.default, title, message())
}
public func logError(_ title: String, _ message: @escaping @autoclosure () -> String = "", file: String = #file, method: String = #function, line: UInt = #line) {
    logError(.default, title, message(), file: file, method: method, line: line)
}
