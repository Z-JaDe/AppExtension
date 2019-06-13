//
//  QQManager.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/21.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
// MARK: -
extension QQManager: ShareItemProtocol {
    public static func shareToQQ(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        shared.setShareCallback(callback)
        guard QQManager.canUseQQShare() else {
            Alert.showPrompt(title: "QQ分享", "请安装QQ客户端")
            return
        }
        let req = shared.getMessageToQQReq(shareModel)
        let sent = QQApiInterface.send(req)
        shared.handleSendResult(sendResult: sent)
    }
    public static func shareToQzone(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        shared.setShareCallback(callback)
        guard QQManager.canUseQzoneShare() else {
            Alert.showPrompt(title: "QQ空间分享", "请安装QQ客户端或者QZone客户端")
            return
        }
        let req = shared.getMessageToQQReq(shareModel)
        let sent = QQApiInterface.sendReq(toQZone: req)
        shared.handleSendResult(sendResult: sent)
    }
}
extension QQManager {
    func getMessageToQQReq(_ shareModel: ShareModel) -> SendMessageToQQReq {
        // swiftlint:disable force_cast
        let newsObj: QQApiNewsObject = QQApiNewsObject.object(with: URL(string: shareModel.url), title: shareModel.title, description: shareModel.content, previewImageURL: URL(string: shareModel.icon)) as! QQApiNewsObject
        return SendMessageToQQReq(content: newsObj)
    }
    func handleSendResult(sendResult: QQApiSendResultCode) {
        self.shareCallBack(isSuccessful: sendResult == EQQAPISENDSUCESS)
        switch sendResult {
        case EQQAPIAPPNOTREGISTED:
            HUD.showPrompt("App未注册")
        case EQQAPIMESSAGECONTENTINVALID, EQQAPIMESSAGECONTENTNULL, EQQAPIMESSAGETYPEINVALID:
            HUD.showPrompt("发送参数错误")
        case EQQAPIQQNOTINSTALLED:
            HUD.showPrompt("未安装手Q")
        case EQQAPIQQNOTSUPPORTAPI:
            HUD.showPrompt("API接口不支持")
        case EQQAPISENDFAILD:
            HUD.showPrompt("发送失败")
        case EQQAPIQZONENOTSUPPORTTEXT:
            HUD.showPrompt("空间分享不支持纯文本分享，请使用图文分享")
        case EQQAPIQZONENOTSUPPORTIMAGE:
            HUD.showPrompt("空间分享不支持纯图片分享，请使用图文分享")
        default:
            break
        }
    }
}
