//
//  ScriptMessageHandler.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/6/1.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import WebKit
//enum ScriptMessage {
//    case share(title: String, content: String, url: String)
//    case close
//    case openPage(uri: String)
//    case error(String)
//    static func all() -> [ScriptMessage] {
//        return [
//            .share(title: "", content: "", url: ""), 
//            .close, 
//            .openPage(uri: "")]
//    }
//    func name() -> String {
//        switch self {
//        case .share(title: _, content: _, url: _): 
//            return "share"
//        case .close: 
//            return "close"
//        case .openPage(uri: _): 
//            return "openPage"
//        case .error(let info): 
//            return info
//        }
//    }
//    static func format(_ message: WKScriptMessage) -> ScriptMessage {
//        switch message.name {
//        case "share": 
//            guard let body = message.body as? NSDictionary as? [String: String] else {
//                return .error(message.name + " body信息错误")
//            }
//            return .share(title: body["title"] ?? "", content: body["content"] ?? "", url: body["url"] ?? "")
//        case "close": 
//            return .close
//        case "openPage": 
//            guard let body = message.body as? NSDictionary as? [String: String] else {
//                return .error(message.name + " body信息错误")
//            }
//            return .openPage(uri: body["uri"] ?? "")
//        default: 
//            return .error(message.name + " 找不到")
//        }
//    }
//}
open class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    /// ZJaDe: 在此注册消息方法
    open func addScriptMessages(in userContentController: WKUserContentController) {

    }
    /// ZJaDe: 在此处理js传过来的消息
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
}
