//
//  AlipayManager+Pay.swift
//  Alamofire
//
//  Created by Apple on 2019/5/15.
//

import Foundation

extension AlipayManager: PayItemProtocol {
    // MARK: - 支付
    public static func requestToPay(_ orderStr: String, _ callback:@escaping CallbackType) {
        shared.setPayCallback(callback)
        AlipaySDK.defaultService().payOrder(orderStr, fromScheme: sdkInfo.scheme) { (resultDict) in
            shared.onPayResp(resultDict)
        }
    }
}
