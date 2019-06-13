//
//  WXOAuthManager.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/21.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation

extension WechatManager: ShareItemProtocol {
    // MARK: - 分享
    public static func shareToWeChat(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        shared.setShareCallback(callback)
        guard WechatManager.canUseWeChat() else {
            Alert.showPrompt(title: "微信分享", "请安装微信客户端")
            return
        }
        let req = shared.getMessageToWXReq(shareModel)
        req.scene = Int32(WXSceneSession.rawValue)
        let result: Bool = WXApi.send(req)
        HUD.showPrompt(result ? "微信分享成功" : "微信分享失败")
        if result == false {
            shared.shareCallBack(isSuccessful: false)
        }
    }
    public static func shareToWeChatTimeline(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        shared.setShareCallback(callback)
        guard WechatManager.canUseWeChat() else {
            Alert.showPrompt(title: "微信朋友圈分享", "请安装微信客户端")
            return
        }
        let req = shared.getMessageToWXReq(shareModel)
        req.scene = Int32(WXSceneTimeline.rawValue)
        let result = WXApi.send(req)
        HUD.showPrompt(result ? "微信朋友圈分享成功" : "微信朋友圈分享失败")
        if result == false {
            shared.shareCallBack(isSuccessful: false)
        }
    }
}
extension WechatManager {
    func getMessageToWXReq(_ shareModel: ShareModel) -> SendMessageToWXReq {
        let message = WXMediaMessage()
        message.title = shareModel.title
        message.description = shareModel.content
        message.setThumbImage(sdkInfo.thumbImage ?? UIImage())
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = shareModel.url
        message.mediaObject = webpageObject

        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        return req
    }

    func onShareResp(_ resp: SendMessageToWXResp) {
        switch WXErrCode(resp.errCode) {
        case WXSuccess:
            HUD.showSuccess("分享成功")
            shareCallBack(isSuccessful: true)
        case WXErrCodeUserCancel:
            HUD.showSuccess("取消分享")
            shareCallBack(isSuccessful: false)
        default:
            HUD.showSuccess("分享失败")
            shareCallBack(isSuccessful: false)
        }
    }
}
