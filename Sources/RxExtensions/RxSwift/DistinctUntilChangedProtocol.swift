//
//  DistinctUntilChangedProtocol.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/11/20.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol DistinctUntilChangedProtocol {
    associatedtype E
    func distinctUntilChanged<K>(_ keySelector: @escaping (E) -> K, comparer: @escaping (K, K) -> Bool) -> Self
    func distinctUntilChanged(_ comparer: @escaping (E, E) -> Bool) -> Self
    func distinctUntilChanged<K: Equatable>(_ keySelector: @escaping (E) -> K) -> Self
}
extension DistinctUntilChangedProtocol {
    public func distinctUntilChanged(_ comparer: @escaping (E, E) -> Bool) -> Self {
        self.distinctUntilChanged({$0}, comparer: comparer)
    }
    public func distinctUntilChanged<K: Equatable>(_ keySelector: @escaping (E) -> K) -> Self {
        self.distinctUntilChanged(keySelector, comparer: {$0 == $1})
    }
}
extension DistinctUntilChangedProtocol where E: Equatable {
    public func distinctUntilChanged() -> Self {
        self.distinctUntilChanged({$0}, comparer: {$0 == $1})
    }
}
