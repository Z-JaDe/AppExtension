//
//  LoadWebUrlProtocol.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/5.
//

import Foundation

public protocol LoadWebUrlProtocol {
    var urlStr: String? {get set}
    func load(_ urlStr: String)
    func loadHTTPUrl(_ string: String)
    func loadHTMLString(_ string: String)
}
public extension LoadWebUrlProtocol {
    func load(_ urlStr: String) {
        if urlStr.hasPrefix("http") {
            loadHTTPUrl(urlStr)
        } else {
            loadHTMLString(urlStr)
        }
    }
}
