//
//  AlipayManager.swift
//  Alamofire
//
//  Created by Apple on 2019/5/15.
//

import Foundation
/**
 Manager作为起始 调用分享、登录或者支付等。
 代理处理放在Manager类中
 */
public class AlipayManager: NSObject {
    static var shared: AlipayManager = AlipayManager()
    private override init() {}
}

/**
 9000    订单支付成功
 8000    正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000    订单支付失败
 5000    重复请求
 6001    用户中途取消
 6002    网络连接出错
 6004    支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它    其它支付错误
 */
extension AlipayManager {
    func onPayResp(_ resultDict: [AnyHashable: Any]?) {
        if let resultDict = resultDict,let memo = resultDict["memo"] as? String {
            if resultDict["resultStatus"] as? String == "9000" {
                self.payCallBack(isSuccessful: true)
                HUD.showSuccess(memo)
            } else {
                self.payCallBack(isSuccessful: false)
                HUD.showError(memo)
            }
        } else {
            HUD.showError("支付宝支付失败，未知错误")
            self.payCallBack(isSuccessful: false)
        }
    }
}
