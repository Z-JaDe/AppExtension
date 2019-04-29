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
extension ModalContainerProtocol where Self: UIViewController & TaskQueueProtocol {
    fileprivate var modalTaskDict: [Int: AsyncTask] {
        get {return associatedObject(&modalIdDictKey, createIfNeed: [: ])}
        set {setAssociatedObject(&modalIdDictKey, newValue)}
    }
    public func contains(_ viewCon: ModalViewController) -> Bool {
        return self.modalTaskDict[viewCon.hashValue] != nil
    }
    public func show(_ viewCon: ModalViewController, animated: Bool = true) {
        guard self.contains(viewCon) == false else {
            return
        }
        let task = self.taskQueue.addAsyncTask({[weak self] (closure) in
            guard let `self` = self else { return }
            self.setAssociatedObject(&modalClosureKey, closure)
            self._show(viewCon, animated: animated)
        })
        self.modalTaskDict[viewCon.hashValue] = task
    }
    public func hide(_ viewCon: ModalViewController, animated: Bool = true, _ callback: AnimateCompletionType? = nil) {
        guard let task = self.modalTaskDict[viewCon.hashValue] else {
            return
        }
        self.modalTaskDict[viewCon.hashValue] = nil
        _ = self.taskQueue.cancelTask(task)

        _hide(viewCon, animated: animated, callback)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let closure: AnimateCompletionType = self.associatedObject(&modalClosureKey) {
                closure()
                let _value: AnimateCompletionType? = nil
                self.setAssociatedObject(&modalClosureKey, _value)
            }
        }
    }
}
