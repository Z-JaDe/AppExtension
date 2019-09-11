//
//  ResponseHandler.swift
//  TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift

public protocol ResultModelHandleProtocol {
    associatedtype ResultCodeType: RawRepresentable & Equatable
    func handle(_ showHUD: ShowNetworkHUD<ResultCodeType>)
}

extension Observable where Element: ResultContextCompatible {
    public func callback(_ closure: @escaping (Element.ValueType?) -> Void) -> Disposable {
        return self.logDebug("_请求回调_").subscribe(onNext: { (element) in
            closure(element.value)
        }, onError: { (error) in
            #if DEBUG
            if let error = error as? NetworkError {
                let text = error.localizedDescription
                HUD.showError(text, delay: 10.0)
            }
            #else
            /// ZJaDe: 如果返回的error字符串为空则不处理
            let errorStr = error.localizedDescription
            if errorStr.isNotEmpty {
                HUD.showError(errorStr)
                logError(errorStr)
            }
            #endif
            closure(nil)
        })
    }
}
// MARK: - result
extension Observable where Element: ResultContextCompatible & ResultModelHandleProtocol {
    public func callback(_ closure: @escaping (Element.ValueType?) -> Void) -> Disposable {
        return self.callback(closure, .default)
    }
    public func callback(_ closure: @escaping (Element.ValueType?) -> Void, _ showHUD: ShowNetworkHUD<Element.ResultCodeType>) -> Disposable {
        return self.logDebug("请求回调").subscribe(onNext: { (result) in
            closure(result.value)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                result.handle(showHUD)
            }
        }, onError: { (error) in
            #if DEBUG
            let text: String
            if let error = error as? NetworkError {
                text = error.localizedDescription
            } else {
                assertionFailure("这里不应该走到，因为前面已经处理过")
                text = "请求错误: \(error)\n\(error.localizedDescription)"
                logError(text)
            }
            showHUD.showResultError(text)
            #else
            /// ZJaDe: 如果返回的error字符串为空则不处理
            let errorStr = error.localizedDescription
            showHUD.showResultError(errorStr)
            #endif
            closure(nil)
        })
    }

}
