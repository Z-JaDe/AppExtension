//
//  Aspect.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/9.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/** ZJaDe:
 Flow 项目中 每个Flow代表 一个界面 或者 一个流程
 遵循对应Flow协议，就可以开启对应流程，比如打开一个注册页，或者打开一个设置页
 */

public protocol Flow: AnyObject {

}

public typealias PushFlow = Flow & NavJumpable

public typealias AnyFlow = Flow

public typealias PresentFlow = Flow & Presentable
public typealias InPresentFlow = Flow & Presentable & CoordinatorContainer

extension NavItemCoordinator: Flow {}
extension ModalCoordinator: Flow {}
