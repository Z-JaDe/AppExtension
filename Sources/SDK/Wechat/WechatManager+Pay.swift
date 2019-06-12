//
//  WXOAuthManager.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/21.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation

public class WechatPayReqModel: Codable {
    public var appid: String?
    public var partnerid: String?
    public var prepayid: String?
    public var package: String?
    public var noncestr: String?
    public var timestamp: UInt32 = 0
    public var sign: String?
}

extension WechatManager: PayItemProtocol {
    // MARK: - 支付
    public static func requestToPay(_ payReqModel: WechatPayReqModel, _ callback:@escaping CallbackType) {
        shared.setPayCallback(callback)
        guard WechatManager.canUseWeChat() else {
            Alert.showPrompt(title: "微信支付", "请检查是否已经安装微信客户端")
            self.shared.payCallBack(isSuccessful: false)
            return
        }
        let request = PayReq()
        request.partnerId = payReqModel.partnerid ?? ""
        request.prepayId = payReqModel.prepayid ?? ""
        request.package = payReqModel.package ?? ""
        request.nonceStr = payReqModel.noncestr ?? ""
        request.timeStamp = payReqModel.timestamp
        request.sign = payReqModel.sign ?? ""
        let result = WXApi.send(request)
        if result == false {
            shared.payCallBack(isSuccessful: false)
        }
    }
}
extension WechatManager {
    func onPayResp(_ resp: PayResp) {
        switch WXErrCode(resp.errCode) {
        case WXSuccess:
            HUD.showSuccess("支付成功")
            self.payCallBack(isSuccessful: true)
        case WXErrCodeUserCancel:
            HUD.showSuccess("取消支付")
            self.payCallBack(isSuccessful: false)
        default:
            HUD.showSuccess("支付失败")
            self.payCallBack(isSuccessful: false)
        }
    }
}
