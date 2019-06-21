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
        return [.centerX, .centerY]
    }
    public static var edges: LayoutEdgeOptions {
        return [.left, .right, .top, .bottom]
    }
}

extension UIView {
    public func equalTo(view: UIView, _ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(self.leftOffset(view, constant: offset))
        }
        if option.contains(.right) {
            array.append(self.rightOffset(view, constant: offset))
        }
        if option.contains(.top) {
            array.append(self.topOffset(view, constant: offset))
        }
        if option.contains(.bottom) {
            array.append(self.bottomOffset(view, constant: offset))
        }
        if option.contains(.centerX) {
            array.append(self.centerXOffset(view, constant: offset))
        }
        if option.contains(.centerY) {
            array.append(self.centerYOffset(view, constant: offset))
        }
        return array
    }
    public func equalToSuperview(_ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return equalTo(view: superView, option, offset: offset)
    }
    public func innerTo(view: UIView, _ option: LayoutEdgeOptions, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(self.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: insets.left))
        }
        if option.contains(.right) {
            array.append(self.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -insets.right))
        }
        if option.contains(.top) {
            array.append(self.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: insets.top))
        }
        if option.contains(.bottom) {
            array.append(self.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -insets.bottom))
        }
        if option.contains(.centerX) {
            array.append(self.centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor, constant: 0))
        }
        if option.contains(.centerY) {
            array.append(self.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: 0))
        }
        return array
    }
    public func innerToSuperview(_ option: LayoutEdgeOptions, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return innerTo(view: superView, option, insets: insets)
    }
    public func innerTo(view: UIView, _ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        var array: [NSLayoutConstraint] = []
        if option.contains(.left) {
            array.append(self.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: offset))
        }
        if option.contains(.right) {
            array.append(self.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: offset))
        }
        if option.contains(.top) {
            array.append(self.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: offset))
        }
        if option.contains(.bottom) {
            array.append(self.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: offset))
        }
        if option.contains(.centerX) {
            array.append(self.centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor, constant: offset))
        }
        if option.contains(.centerY) {
            array.append(self.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: offset))
        }
        return array
    }
    public func innerToSuperview(_ option: LayoutEdgeOptions, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superView = superview else {
            fatalError("superview为nil")
        }
        return innerTo(view: superView, option, offset: offset)
    }
}
