//
//  ModalContainerProtocol.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/19.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import ModalManager

private var modalClosureKey: UInt8 = 0
private var modalIdDictKey: UInt8 = 0
extension ModalContainerProtocol where Self: UIViewController&TaskProtocol {
    fileprivate var modalTaskDict: [ModalViewController: AsyncTask] {
        get {return associatedObject(&modalIdDictKey, createIfNeed: [: ])}
        set {setAssociatedObject(&modalIdDictKey, newValue)}
    }
    public func contains(_ viewCon: ModalViewController) -> Bool {
        return self.modalTaskDict[viewCon] != nil
    }
    public func show(_ viewCon: ModalViewController, animated: Bool = true) {
        guard self.contains(viewCon) == false else {
            return
        }
        let task = self.addAsyncTask({[weak self] (closure) in
            guard let `self` = self else { return }
            self.setAssociatedObject(&modalClosureKey, closure)
            self._show(viewCon, animated: animated)
        })
        self.modalTaskDict[viewCon] = task
    }
    public func hide(_ viewCon: ModalViewController, animated: Bool = true, _ callback: AnimateCompletionType? = nil) {
        guard let task = self.modalTaskDict[viewCon] else {
            return
        }
        self.modalTaskDict[viewCon] = nil
        _ = self.cancelTask(task)

        _hide(viewCon, animated: animated, callback)
        Async.main(after: 0.2) {
            if let closure: AnimateCompletionType = self.associatedObject(&modalClosureKey) {
                closure()
                let _value: AnimateCompletionType? = nil
                self.setAssociatedObject(&modalClosureKey, _value)
            }
        }
    }
}
