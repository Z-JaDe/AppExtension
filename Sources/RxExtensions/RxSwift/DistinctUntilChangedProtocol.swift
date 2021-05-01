//
//  DistinctUntilChangedProtocol.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/11/20.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol DistinctUntilChangedProtocol {
    associatedtype Element
    func distinctUntilChanged<K>(_ keySelector: @escaping (Element) -> K, comparer: @escaping (K, K) -> Bool) -> Self
    func distinctUntilChanged(_ comparer: @escaping (Element, Element) -> Bool) -> Self
    func distinctUntilChanged<K: Equatable>(_ keySelector: @escaping (Element) -> K) -> Self
}
extension DistinctUntilChangedProtocol {
    public func distinctUntilChanged(_ comparer: @escaping (Element, Element) -> Bool) -> Self {
        self.distinctUntilChanged({$0}, comparer: comparer)
    }
    public func distinctUntilChanged<K: Equatable>(_ keySelector: @escaping (Element) -> K) -> Self {
        self.distinctUntilChanged(keySelector, comparer: {$0 == $1})
    }
}
extension DistinctUntilChangedProtocol where Element: Equatable {
    public func distinctUntilChanged() -> Self {
        self.distinctUntilChanged({$0}, comparer: {$0 == $1})
    }
}
