//
//  WechatManager+Login.swift
//  Alamofire
//
//  Created by Apple on 2019/5/15.
//

import Foundation
import Alamofire
extension DefaultsKeys {
    // MARK: - wechat
    public static let wx_refresh_token = DefaultsKey<String>("wx_refresh_token", defaultValue: "")
    public static let wx_access_token = DefaultsKey<String>("wx_access_token", defaultValue: "")
    public static let wx_openId = DefaultsKey<String>("wx_openId", defaultValue: "")
    public static let wx_unionId = DefaultsKey<String>("wx_unionId", defaultValue: "")
}
extension WechatManager: ThirdLoginPluginProtocol {
    public typealias LoginPlugin = WeChatLoginPlugin
    public internal(set) static var login: LoginPlugin?
}
public class WeChatLoginPlugin: ThirdLoginPlugin {
    override func configInit() {
        super.configInit()
        WechatManager.login = self
    }
    // MARK: -
    let openId_key: String = "openid"
    let unionId_key: String = "unionid"
    let access_token_key: String = "access_token"
    let refresh_token_key: String = "refresh_token"

    let errcode_key: String = "errcode"
    let errmsg_key: String = "errmsg"
    // MARK: - 登录
    override func jumpAndAuth() {
        guard WechatManager.canUseWeChat() else {
            Alert.showPrompt(title: "微信登录", "请检查是否已经安装微信客户端")
            return
        }
        let req = SendAuthReq()
        req.scope = sdkInfo.wechatAuthScope
        /// ZJaDe: -[SendAuthReq setOpenId:]: unrecognized selector sent to instance 0x17064b19
        //        req.openId = Defaults[.wx_openId]
        if let viewCon = UIApplication.shared.keyWindow?.rootViewController {
            WXApi.sendAuthReq(req, viewController: viewCon, delegate: WechatManager.shared)
        }
    }
    // MARK: -
    override func requestLogin() {
        self.wechatRefreshToken {
            super.requestLogin()
        }
    }
}
extension WeChatLoginPlugin {
    func wechatAccessToken(_ resp: SendAuthResp) {
        guard resp.errCode == WXSuccess.rawValue else { return }
        let hud = HUD.showMessage("获取微信登录参数中")
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token"
        var params = [String: Any]()
        params["code"] = resp.code
        params["grant_type"] = "authorization_code"
        params["secret"] = sdkInfo.wechatAppSecret
        params["appid"] = sdkInfo.wechatAppid
        Alamofire.request(urlStr, method: .post, parameters: params).responseJSON { (response) in
            hud.hide()
            guard let dict = response.result.value as? NSDictionary, dict[self.errcode_key] == nil else {
                Alert.showConfirm(title: "微信登录", "获取微信登录参数出错，请重新获取授权", { (_, _) in
                    self.jumpAndAuth()
                })
                return
            }
            Defaults[.wx_access_token] = dict[self.access_token_key] as? String ?? ""
            Defaults[.wx_refresh_token] = dict[self.refresh_token_key] as? String ?? ""
            Defaults[.wx_openId] = dict[self.openId_key] as? String ?? ""
            Defaults[.wx_unionId] = dict[self.unionId_key] as? String ?? ""
            self.request()
        }
    }
    private func wechatRefreshToken(_ callback:@escaping () -> Void) {
        let hud = HUD.showMessage("刷新微信登录参数中")
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/refresh_token"
        var params = [String: Any]()
        params["appid"] = sdkInfo.wechatAppid
        params["grant_type"] = refresh_token_key
        params[refresh_token_key] = Defaults[.wx_refresh_token]
        Alamofire.request(urlStr, method: .post, parameters: params).responseJSON { (response) in
            hud.hide()
            guard let dict = response.result.value as? NSDictionary, dict[self.errcode_key] == nil, dict[self.refresh_token_key] != nil else {
                Alert.showConfirm(title: "微信登录", "微信登录失效，请重新获取授权", { (_, _) in
                    self.jumpAndAuth()
                })
                return
            }
            Defaults[.wx_access_token] = dict[self.access_token_key] as? String ?? ""
            callback()
        }
    }
}
