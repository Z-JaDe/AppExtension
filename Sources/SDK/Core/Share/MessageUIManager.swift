//
//  EmailManager.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 17/3/21.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import MessageUI

public class MessageUIManager: NSObject {
    public typealias CallbackType = (Bool) -> Void
    static var shared: MessageUIManager = MessageUIManager()
    private override init() {
        super.init()
    }
    // MARK: - 邮件分享
    public static func shareToEmail(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        guard MessageUIManager.canUseEmail() else {
            Alert.showPrompt(title: "邮箱分享", "无法使用邮箱分享")
            callback(false)
            return
        }
        let picker = MFMailComposeViewController()
        picker.setSubject(shareModel.title)
        picker.setMessageBody(shareModel.text, isHTML: false)
        picker.mailComposeDelegate = shared
        UIApplication.shared.keyWindow?.rootViewController?.present(picker)
        callback(true)
    }
    // MARK: - 短信分享
    public static func shareToMessage(_ shareModel: ShareModel, _ callback:@escaping CallbackType) {
        guard MessageUIManager.canUseMessage() else {
            Alert.showPrompt(title: "短信分享", "无法使用短信分享")
            callback(false)
            return
        }
        let picker = MFMessageComposeViewController()
        picker.subject = shareModel.title
        picker.body = shareModel.text
        picker.messageComposeDelegate = shared
        UIApplication.shared.keyWindow?.rootViewController?.present(picker)
        callback(true)
    }

}
extension MessageUIManager {
    public static func canUseEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    public static func canUseMessage() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
}
extension MessageUIManager: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            HUD.showPrompt("已经点击发送")
        }
        controller.dismissVC()
    }
}
extension MessageUIManager: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .sent {
            HUD.showPrompt("已经点击发送")
        }
        controller.dismissVC()
    }
}
