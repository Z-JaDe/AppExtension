//
//  AlipayManager+Pay.swift
//  Alamofire
//
//  Created by Apple on 2019/5/15.
//

import Foundation

extension AlipayManager: PayItemProtocol {
    // MARK: - 支付
    public func requestToPay(_ orderStr:String, _ callback:@escaping CallbackType) {
        self.setPayCallback(callback)
        AlipaySDK.defaultService().payOrder(orderStr, fromScheme: sdkInfo.scheme) { (resultDict) in
            self.onPayResp(resultDict)
        }
    }
}
