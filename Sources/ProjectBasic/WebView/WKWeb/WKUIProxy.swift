//
//  WKUIProxy.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/6/1.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import WebKit
class WKUIProxy: NSObject, WKUIDelegate {
    // MARK: - WKUIDelegate
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        Alert.showPrompt(message) { (_, _) in
            completionHandler()
        }
    }
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        Alert.showConfirm(title: "请确认", message, { (_, _) in
            completionHandler(true)
        }, { (_, _) in
            completionHandler(false)
        })
    }
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        Alert.alert(message: prompt)
            .addTextInputAction(placeholder: defaultText ?? "", { (_, _) in

        }).addDefaultAction(title: "确定") { (alertVC, _) in
            var text = alertVC.textFields?.first?.text
            if text.isNilOrEmpty {
                text = alertVC.textFields?.first?.placeholder
            }
            completionHandler(text)
            }.addCancelAction(title: "取消", { (_, _) in
                completionHandler(nil)
            }).show()
    }
}
