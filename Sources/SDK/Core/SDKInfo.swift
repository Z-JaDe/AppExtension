//
//  SDK.swift
//  SDK
//
//  Created by 茶古电子商务 on 2017/11/16.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

@_exported import AppExtension
@_exported import SwiftyUserDefaults
/**
 先把appId等数据设置好，然后合适的地方调用register以及application方法
 */
public let sdkInfo = SDKInfo()
public class SDKInfo {
    fileprivate init() {}
    public var scheme: String = "app"
    public var thumbImage: UIImage?
    // MARK: - 三方
    //    public let aliyunApiAppCode: String = ""
    public var tencentAppid: String = ""
//    public var tencentAppKey: String = ""
    public var wechatAppid: String = ""
    public var wechatAppSecret: String = ""
    public var wechatAuthScope: String = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
    
    public func register() {
        if !wechatAppid.isEmpty {
            WXApi.registerApp(wechatAppid)
        }
    }
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        var result = false
        if result == false {
            result = WXApi.handleOpen(url, delegate: WechatManager.shared)
        }
        if result == false && TencentOAuth.canHandleOpen(url) {
            result = TencentOAuth.handleOpen(url)
        }
        if result == false {
            if url.host == "safepay" || url.host == "platformapi" {
                AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                    AlipayManager.shared.onPayResp(resultDic)
                })
                result = true
            }
        }
        return result
    }
}
