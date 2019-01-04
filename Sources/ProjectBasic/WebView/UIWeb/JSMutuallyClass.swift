//
//  JSMutuallyClass.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/13.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import JavaScriptCore
/** ZJaDe: 
 想要实现交互首先 设置给上下文的交互类需要实现一个协议，这个协议需要继承JSExport，同时声明出来可能存在的交互方法，还需要@objc标记
 */
/** ZJaDe: 
 例子：
 @objc public protocol JSMutuallyProtocol: JSExport {
 
 }
 open class JSMutuallyClass: NSObject, JSMutuallyProtocol {
 
 }
 */
