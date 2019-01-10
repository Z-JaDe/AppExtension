//
//  ResultModelType.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/11/23.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol AbstractResultModelType {
    associatedtype ResultCodeType: RawRepresentable & Equatable
    var resultCode: ResultCodeType? {get}
}
public protocol ResultModelHandleProtocol {
    associatedtype ResultCodeType: RawRepresentable & Equatable
    func handle(_ showHUD: ShowNetworkHUD<ResultCodeType>)
}
