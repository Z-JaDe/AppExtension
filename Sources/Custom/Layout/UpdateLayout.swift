////
////  UpdateLayout.swift
////  ZiWoYou
////
////  Created by 茶古电子商务 on 16/11/11.
////  Copyright © 2016 Z_JaDe. All rights reserved.
////

import UIKit
import SnapKit

private var updateLayoutArrKey: UInt8 = 0
extension UIView {
    public var jdLayout: UpdateLayout {
        return UpdateLayout(view: self)
    }
    public func updateLayouts(tag: String = UpdateLayout.defaultTag, _ closure: @autoclosure () -> ([Constraint])) {
        jdLayout.deactivate(tag: tag)
        var constraintArr = jdLayout.constraintDict[tag] ?? []
        constraintArr += closure()
        jdLayout.constraintDict[tag] = constraintArr
        jdLayout.activate(tag: tag)
    }
    public func updateLayoutsMaker(tag: String = UpdateLayout.defaultTag, _ closure: (ConstraintMaker) -> Void) {
        self.updateLayouts(tag: tag, self.snp.prepareConstraints(closure))
    }
}
public class UpdateLayout: CustomDebugStringConvertible {
    public let view: UIView
    public static let defaultTag: String = "_default"
    public var constraintDict: [String: [Constraint]] {
        get {
            return self.view.associatedObject(&updateLayoutArrKey, createIfNeed: [: ])
        }
        set {
            self.view.setAssociatedObject(&updateLayoutArrKey, newValue)
        }
    }
    public init(view: UIView) {
        self.view = view
    }
    // MARK: -
    public func activate(tag: String) {
        self.constraintDict[tag]?.forEach { (constraint) in
            constraint.activate()
        }
    }
    public func deactivate(tag: String) {
        self.constraintDict[tag]?.forEach { (constraint) in
            if constraint.isActive {
                constraint.deactivate()
            }
        }
        self.constraintDict[tag] = nil
    }
    // MARK: - 
    public var debugDescription: String {
        return "UpdateLayout: \(self.constraintDict)"
    }
}
