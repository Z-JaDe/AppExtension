//
//  QQManager.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/21.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
/**
 Manager作为起始 调用分享、登录或者支付等。
 代理处理放在Manager类中
 */
public class QQManager: NSObject, ThirdLoginPluginProtocol {
    public static var shared: QQManager = QQManager()
    private override init() {
        super.init()
        tencentOAuth.authShareType = AuthShareType_QQ
    }
    public typealias LoginPlugin = QQLoginPlugin
    public internal(set) var login: LoginPlugin?
    
    lazy var tencentOAuth: TencentOAuth = {
        let tencentAppid = sdkInfo.tencentAppid
        let tencentOAuth = TencentOAuth(appId: tencentAppid, andDelegate: self)!
        return tencentOAuth
    }()
}

extension QQManager {
    public static func canUseQQShare() -> Bool {
        return TencentOAuth.iphoneQQInstalled()
    }
    public static func canUseQQLogin() -> Bool {
        return TencentOAuth.iphoneQQSupportSSOLogin()
    }
    public static func canUseQzoneShare() -> Bool {
        return canUseQQShare()
    }
}

extension QQManager: TencentSessionDelegate {
    public func tencentDidLogin() {
        guard let accessToken = self.tencentOAuth.accessToken, accessToken.count > 0 else {
            return
        }
        Defaults[.qq_access_token] = self.tencentOAuth.accessToken
        Defaults[.qq_openId] = self.tencentOAuth.openId
        Defaults[.qq_expirationDate] = self.tencentOAuth.expirationDate
        self.login?.request()
    }
    public func tencentDidNotLogin(_ cancelled: Bool) { }
    public func tencentDidNotNetWork() { }
    public func responseDidReceived(_ response: APIResponse!, forMessage message: String!) {
        guard let response = response else { return }
        logDebug("QQ -> responseDidReceived -> response:\(response), message:\(message ?? "")")
    }
}
