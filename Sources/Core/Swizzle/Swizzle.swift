//
//  Swizzle.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 16/9/15.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
public protocol SelectorProtocol {
    var selectorValue: Selector {get}
}

extension Selector: SelectorProtocol {
    public var selectorValue: Selector {
        return self
    }
}
extension String: SelectorProtocol {
    public var selectorValue: Selector {
        return NSSelectorFromString(self)
    }
}
extension NSObject {
    /// ZJaDe: 未完善 不可用
    @discardableResult
    public class func swizzle<T: SelectorProtocol, U: SelectorProtocol>(original: T, swizzled: U) -> Bool {
        let originalSel = original.selectorValue
        let swizzledSel = swizzled.selectorValue
        guard let originalMethod = class_getInstanceMethod(self, originalSel) else {
            return false
        }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSel) else {
            return false
        }

        class_addMethod(self, originalSel, class_getMethodImplementation(self, originalSel)!, method_getTypeEncoding(originalMethod))
        class_addMethod(self, swizzledSel, class_getMethodImplementation(self, swizzledSel)!, method_getTypeEncoding(swizzledMethod))

        method_exchangeImplementations(class_getInstanceMethod(self, originalSel)!, class_getInstanceMethod(self, swizzledSel)!)
        return true
    }
}
