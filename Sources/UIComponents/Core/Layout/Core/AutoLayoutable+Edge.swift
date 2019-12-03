//
//  UIView+Edge.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import UIKit

public struct LayoutEdgeOptions: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let left: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 0)
    public static let right: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 1)
    public static let top: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 2)
    public static let bottom: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 3)
    public static let centerX: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 4)
    public static let centerY: LayoutEdgeOptions = LayoutEdgeOptions(rawValue: 1 << 5)

    public static var center: LayoutEdgeOptions {
        [.centerX, .centerY]
    }
    public static var edges: LayoutEdgeOptions {
        [.left, .right, .top, .bottom]
    }
}

extension AutoLayoutable {
    public func equalTo(view: AutoLayoutable, _ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        prepare()
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(leftOffset(view, constant: offset))
        }
        if option.contains(.right) {
            array.append(rightOffset(view, constant: offset))
        }
        if option.contains(.top) {
            array.append(topOffset(view, constant: offset))
        }
        if option.contains(.bottom) {
            array.append(bottomOffset(view, constant: offset))
        }
        if option.contains(.centerX) {
            array.append(centerXOffset(view, constant: offset))
        }
        if option.contains(.centerY) {
            array.append(centerYOffset(view, constant: offset))
        }
        return array
    }
    public func innerTo(view: AutoLayoutable, _ option: LayoutEdgeOptions, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        prepare()
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: insets.left))
        }
        if option.contains(.right) {
            array.append(rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -insets.right))
        }
        if option.contains(.top) {
            array.append(topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: insets.top))
        }
        if option.contains(.bottom) {
            array.append(bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -insets.bottom))
        }
        if option.contains(.centerX) {
            array.append(centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor, constant: 0))
        }
        if option.contains(.centerY) {
            array.append(centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 0))
        }
        return array
    }
    public func innerTo(view: AutoLayoutable, _ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        prepare()
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: offset))
        }
        if option.contains(.right) {
            array.append(rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: offset))
        }
        if option.contains(.top) {
            array.append(topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: offset))
        }
        if option.contains(.bottom) {
            array.append(bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: offset))
        }
        if option.contains(.centerX) {
            array.append(centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor, constant: offset))
        }
        if option.contains(.centerY) {
            array.append(centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: offset))
        }
        return array
    }
}
extension UIView {
    public func equalToSuperview(_ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return equalTo(view: superView, option, offset: offset)
    }
    public func innerToSuperview(_ option: LayoutEdgeOptions, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return innerTo(view: superView, option, insets: insets)
    }
    public func innerToSuperview(_ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return innerTo(view: superView, option, offset: offset)
    }
}
