//
//  ResultHandleProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/9/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol ResultHandleProtocol {
    associatedtype ResultCodeType: RawRepresentable & Equatable
    func handleResult(_ showHUD: ShowNetworkHUD<ResultCodeType>)
}
extension Observable where Element: ResponseContextCompatible & ResultHandleProtocol {
    func showHUDWhenComplete(_ showHUD: ShowNetworkHUD<Element.ResultCodeType>) -> Observable<Element> {
        `do`(afterNext: { (element) in
            element.handleResult(showHUD)
        }, afterError: { (error) in
            showHUD.showResultError(error)
        })
    }
}
extension Observable where Element: ResponseContextCompatible & ResultHandleProtocol {
    public func hudCallback(_ closure: @escaping (Element.ResultValue?) -> Void) -> Disposable {
        self.showHUDWhenComplete(.default).callback(closure)
    }
}

extension Observable where Element: RequestContextCompatible {
    func showProgressHUD(_ text: String, in view: UIView? = nil) -> Observable<Element> {
        var hud: HUD?
        return `do`(afterCompleted: {
            hud?.hide()
        }, onSubscribed: {
            hud = HUD.showMessage(text, to: view)
        })
    }
    func showProgressHUD(_ text: String, in hudManager: MessageHUDProtocol) -> Observable<Element> {
        return `do`(afterCompleted: {
            hudManager.hideMessage(text)
        }, onSubscribed: {
            _ = hudManager.showMessage(text)
        })
    }
}
