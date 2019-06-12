//
//  WXOAuthManager.swift
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
public class WechatManager: NSObject {
    static var shared: WechatManager = WechatManager()
    private override init() {}
}

extension WechatManager {
    public static func canUseWeChat() -> Bool {
        return WXApi.isWXAppInstalled() && WXApi.isWXAppSupport()
    }
}

extension WechatManager: WXApiDelegate {
    // MARK: - delegate
    public func onResp(_ resp: BaseResp) {
        if let resp = resp as? SendAuthResp {
            // MARK: - 登录回调
            WechatManager.login?.wechatAccessToken(resp)
        } else if let resp = resp as? PayResp {
            self.onPayResp(resp)
        } else if let resp = resp as? SendMessageToWXResp {
            self.onShareResp(resp)
        }
    }
}
