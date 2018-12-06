//
//  NetworkProtocol.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol NetworkProtocol: class {

    var requestUpdateTask: NeedUpdateTask {get}
    var dataUpdateTask: NeedUpdateTask {get}
    /// ZJaDe: NetworkProtocol: 请求
    func request()
    /// ZJaDe: NetworkProtocol: 更新数据
    func updateData()
}
