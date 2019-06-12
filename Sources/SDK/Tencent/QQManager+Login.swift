//
//  QQManager+Login.swift
//  Alamofire
//
//  Created by Apple on 2019/5/15.
//

import Foundation

extension DefaultsKeys {
    // MARK: - QQ
    public static let qq_access_token = DefaultsKey<String>("qq_access_token", defaultValue: "")
    public static let qq_openId = DefaultsKey<String>("qq_openId", defaultValue: "")
    public static let qq_expirationDate = DefaultsKey<Date?>("qq_expirationDate")
}
extension QQManager: ThirdLoginPluginProtocol {
    public internal(set) static var login: LoginPlugin?
    public typealias LoginPlugin = QQLoginPlugin
}
public class QQLoginPlugin: ThirdLoginPlugin {
    override func configInit() {
        super.configInit()
        QQManager.login = self
    }
    var tencentOAuth: TencentOAuth {
        return QQManager.shared.tencentOAuth
    }
    // MARK: -
    override func jumpAndAuth() {
        guard QQManager.canUseQQLogin() else {
            Alert.showPrompt(title: "QQ登录", "请安装QQ客户端")
            return
        }
        let permissions = [kOPEN_PERMISSION_GET_USER_INFO,
                           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                           kOPEN_PERMISSION_ADD_ONE_BLOG,
                           kOPEN_PERMISSION_ADD_SHARE,
                           kOPEN_PERMISSION_ADD_TOPIC,
                           kOPEN_PERMISSION_CHECK_PAGE_FANS,
                           kOPEN_PERMISSION_GET_INFO,
                           kOPEN_PERMISSION_GET_OTHER_INFO,
                           kOPEN_PERMISSION_LIST_ALBUM,
                           kOPEN_PERMISSION_UPLOAD_PIC,
                           kOPEN_PERMISSION_GET_VIP_INFO,
                           kOPEN_PERMISSION_GET_VIP_RICH_INFO]
        tencentOAuth.authorize(permissions)
    }
    
    // MARK: -
    override func requestLogin() {
        self.qqRefreshToken {
            super.requestLogin()
        }
    }
}
extension QQLoginPlugin {
    func qqRefreshToken(_ callback:@escaping () -> Void) {
        guard let expirationDate = Defaults[.qq_expirationDate] else {
            Alert.showConfirm(title: "QQ登录", "QQ登录出现问题，请重新获取授权", { (_, _) in
                self.jumpAndAuth()
            })
            return
        }
        guard expirationDate > Date(timeIntervalSinceNow: -3600) else {
            Alert.showConfirm(title: "QQ登录", "QQ登录失效，请重新获取授权", { (_, _) in
                self.jumpAndAuth()
            })
            return
        }
        callback()
    }
}
