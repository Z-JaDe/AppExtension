//
//  ResultHandleProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/9/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxNetwork

public protocol ResultHandleProtocol {
    func handleResult(_ showHUD: ShowNetworkHUD)
}
extension Observable where Element: ResultHandleProtocol {
    public func showHUDWhenComplete(_ showHUD: ShowNetworkHUD) -> Observable<Element> {
        `do`(afterNext: { (element) in
            element.handleResult(showHUD)
        }, afterError: { (error) in
            showHUD.showResultError(error)
        })
    }
}

