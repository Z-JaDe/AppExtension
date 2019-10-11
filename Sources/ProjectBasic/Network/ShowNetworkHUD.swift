//
//  ResultModelType.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

public typealias TaskVC = MessageHUDProtocol & TaskQueueProtocol

public enum ShowNetworkHUD<ResultCodeType> where ResultCodeType: RawRepresentable & Equatable {
    case `default`
    case hide
    ///忽略不展示的错误码
    case ignoreErrorCodes([ResultCodeType])
    case show
    case showIn(UIViewController & TaskVC)
}

public extension ShowNetworkHUD {
    func showResultSuccessful(_ text: String) {
        guard text.isNotEmpty else {
            return
        }
        switch self {
        case .default, .hide, .ignoreErrorCodes:
            break
        case .show:
            HUD.showSuccess(text)
        case .showIn(let viewCon):
            viewCon.taskQueue.addTask({ [weak viewCon] in
                viewCon?.showSuccess(text)
            })
        }
    }
    func showResultError(_ error: Error) {
        let error = error._mapError()
        #if DEBUG
        let text: String
        switch error {
        case let error as NetworkError:
            text = error.localizedDescription
        default:
            text = "请求错误: \(error)\n\(error.localizedDescription)"
            logError(text)
            assertionFailure("这里不应该走到，因为前面已经处理过")
        }
        showResultError(text)
        #else
        /// ZJaDe: 如果返回的error字符串为空则不处理
        let errorStr = error.localizedDescription
        showResultError(errorStr)
        #endif

    }
    func showResultError(_ text: String, resultCode: ResultCodeType? = nil) {
        guard text.isNotEmpty else {
            return
        }
        switch self {
        case .hide:
            break
        case .ignoreErrorCodes(let resultCodes):
            guard let resultCode = resultCode else {
                return
            }
            if resultCodes.contains(resultCode) == false {
                #if DEBUG
                HUD.showError(text, delay: 10.0)
                #else
                HUD.showError(text)
                #endif
            }
        case .default, .show:
            #if DEBUG
            HUD.showError(text, delay: 10.0)
            #else
            HUD.showError(text)
            #endif
        case .showIn(let viewCon):
            viewCon.taskQueue.addTask({ [weak viewCon] in
                viewCon?.showError(text)
            })
        }
    }
}
