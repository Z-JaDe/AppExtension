//
//  DisposeBagProtocol.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/11/20.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift

public let globalDisposeBag: DisposeBag = DisposeBag()

public protocol DisposeBagProtocol: AssociatedObjectProtocol {
    var disposeBag: DisposeBag {get set}
    func resetDisposeBag()
}

private var jdDisposeBagKey: UInt8 = 0
extension DisposeBagProtocol {
    public var disposeBag: DisposeBag {
        get {return associatedObject(&jdDisposeBagKey, createIfNeed: DisposeBag())}
        set {setAssociatedObject(&jdDisposeBagKey, newValue)}
    }
    public func resetDisposeBag() {
        self.disposeBag = DisposeBag()
    }
}
// MARK: -
private var jdDisposeBagDictKey: UInt8 = 0
public extension DisposeBagProtocol {
    @discardableResult
    func resetDisposeBagWithTag(_ tag: String) -> DisposeBag {
        let bag = DisposeBag()
        self.setDisposeBag(tag: tag, bag)
        return bag
    }
    func disposeBagWithTag(_ tag: String) -> DisposeBag {
        var dict: [String: DisposeBag] = associatedObject(&jdDisposeBagDictKey, createIfNeed: [: ])
        if let result = dict[tag] {
            return result
        } else {
            let result = DisposeBag()
            saveDict(&dict, tag, result)
            return result
        }
    }
    func optionalDisposeBagWithTag(_ tag: String) -> DisposeBag? {
        let dict: [String: DisposeBag] = associatedObject(&jdDisposeBagDictKey, createIfNeed: [: ])
        if let result = dict[tag] {
            return result
        } else {
            return nil
        }
    }
    func setDisposeBag(tag: String, _ disposeBag: DisposeBag) {
        var dict: [String: DisposeBag] = associatedObject(&jdDisposeBagDictKey, createIfNeed: [: ])
        saveDict(&dict, tag, disposeBag)
    }
    private func saveDict(_ dict: inout [String: DisposeBag], _ tag: String, _ disposeBag: DisposeBag) {
        dict[tag] = disposeBag
        setAssociatedObject(&jdDisposeBagDictKey, dict)
    }
}

extension NSObject: DisposeBagProtocol {}
extension Reactive where Base: DisposeBagProtocol {
    public var disposeBag: DisposeBag {
        base.disposeBag
    }
}
