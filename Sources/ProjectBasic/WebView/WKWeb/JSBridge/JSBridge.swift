//
//  JSBridge.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/3/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import WebKit

public struct AbortedError: Error {}

public struct JSError: Error, Codable {
    public let name: String
    public let message: String
    public let stack: String

    public let line: Int
    public let column: Int

    public let code: String?
}

open class JSBridge {
    public let webView: JDWKWebView
    internal let context: Context

    public init(libraryCode: String, customOrigin: URL? = nil, incognito: Bool = false, functionNamespace: String) {

        self.context = Context(functionNamespace: functionNamespace)
        self.webView = self.context.createWebView(libraryCode: libraryCode, customOrigin: customOrigin, incognito: incognito)
    }
}
