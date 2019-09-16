////
////  UpdateLayout.swift
////  ZiWoYou
////
////  Created by 茶古电子商务 on 16/11/11.
////  Copyright © 2016 Z_JaDe. All rights reserved.
////

import UIKit

// MARK: -
public protocol ConstraintProtocol: class {
    var isActive: Bool { get set }
}
extension NSLayoutConstraint: ConstraintProtocol {}
extension UIView {
    public var autoLayout: UpdateLayout<NSLayoutConstraint> {
        UpdateLayout(view: self)
    }
    public func updateLayouts(tag: String? = nil, _ closure: @autoclosure () -> ([NSLayoutConstraint])) {
        autoLayout.updateLayouts(tag: tag, closure())
    }
}
// MARK: -
private var updateLayoutArrKey: UInt8 = 0
private let defaultLayoutTag: String = "_default"
public class UpdateLayout<Constraint: ConstraintProtocol>: CustomDebugStringConvertible {
    public let view: UIView
    public var constraintDict: [String: [Constraint]] {
        get { self.view.associatedObject(&updateLayoutArrKey, createIfNeed: [: ]) }
        set { self.view.setAssociatedObject(&updateLayoutArrKey, newValue) }
    }
    public init(view: UIView) {
        self.view = view
    }
    // MARK: -
    public func activate(tag: String) {
        self.constraintDict[tag]?.forEach {$0.isActive = true}
    }
    public func deactivate(tag: String) {
        self.constraintDict[tag]?.lazy.filter({$0.isActive}).forEach {$0.isActive = false}
        self.constraintDict[tag] = nil
    }
    // MARK: -
    public func updateLayouts(tag: String? = nil, _ closure: @autoclosure () -> ([Constraint])) {
        let tag = tag ?? defaultLayoutTag
        deactivate(tag: tag)
        var constraintArr = constraintDict[tag] ?? []
        constraintArr += closure()
        constraintDict[tag] = constraintArr
        activate(tag: tag)
    }
    // MARK: - 
    public var debugDescription: String {
        "UpdateLayout: \(self.constraintDict)"
    }
}
