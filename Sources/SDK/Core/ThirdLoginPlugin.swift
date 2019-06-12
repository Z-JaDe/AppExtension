//
//  ThirdLoginPlugin.swift
//  SDK
//
//  Created by 茶古电子商务 on 2017/11/16.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

public class ThirdLoginPlugin: NSObject {
    enum ThirdAuthType {
        case binding
        case login
        case requestLogin
    }
    let authType: ThirdAuthType
    /// ZJaDe: 存储登录和绑定的请求闭包
    let callback: () -> Void
    required init(_ authType: ThirdAuthType, _ callback: @escaping () -> Void) {
        self.authType = authType
        self.callback = callback
        super.init()
        configInit()
    }
    func configInit() {
    }
    /// ZJaDe: 子类继承跳转第三方app逻辑
    func jumpAndAuth() {

    }
    /// ZJaDe: 子类直接调用
    func request() {
        self.callback()
    }
    /// ZJaDe: 请求登录并检查参数有效期 --子类继承
    func requestLogin() {
        self.callback()
    }
}
public protocol ThirdLoginPluginProtocol: class {
    associatedtype LoginPlugin: ThirdLoginPlugin
    /// ZJaDe: 跳转第三方app并请求绑定
    static func jumpBinding(_ callback: @escaping () -> Void)
    /// ZJaDe: 跳转第三方app并请求登录
    static func jumpLoginAndAuth(_ callback: @escaping () -> Void)
    static func requestLoginAndRefreshParams(_ callback: @escaping () -> Void)
}
public extension ThirdLoginPluginProtocol {
    // MARK: -
    public static func jumpBinding(_ callback: @escaping () -> Void) {
        let plugin = LoginPlugin.init(.binding, callback)
        plugin.jumpAndAuth()
    }
    public static func jumpLoginAndAuth(_ callback: @escaping () -> Void) {
        let plugin = LoginPlugin.init(.login, callback)
        plugin.jumpAndAuth()
    }
    /// ZJaDe: 请求登录并检查参数有效期
    public static func requestLoginAndRefreshParams(_ callback: @escaping () -> Void) {
        let plugin = LoginPlugin.init(.requestLogin, callback)
        plugin.requestLogin()
    }
}
