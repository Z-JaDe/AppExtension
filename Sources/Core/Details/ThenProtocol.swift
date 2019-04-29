//
//  ThenProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 16/11/16.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation

public protocol ThenProtocol {

}
extension ThenProtocol where Self: Any {
    public func then_Any(_ closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
extension ThenProtocol where Self: AnyObject {
    @discardableResult
    public func then(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    @discardableResult
    public func thenMain(_ closure: @escaping (Self) -> Void) -> Self {
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
            closure(self)
        }
        return self
    }
}
extension NSObject: ThenProtocol {}
