//
//  UIView+Position.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public enum LayoutOptions {
    case start(CGFloat)
    case centerOffset(CGFloat)
    case end(CGFloat)
    case fill(CGFloat, CGFloat)
}

extension UIView {
    public func horizontal(_ other: AutoLayoutable, _ position: LayoutOptions) -> [NSLayoutConstraint] {
        switch position {
        case .start(let offset):
            return [leftOffset(other, constant: offset)]
        case .centerOffset(let offset):
            return [centerXOffset(other, constant: offset)]
        case .end(let offset):
            return [rightOffset(other, constant: -offset)]
        case .fill(let left, let right):
            return [
                leftOffset(other, constant: left),
                rightOffset(other, constant: -right)
            ]
        }
    }
    public func vertical(_ other: AutoLayoutable, _ position: LayoutOptions) -> [NSLayoutConstraint] {
        switch position {
        case .start(let offset):
            return [topOffset(other, constant: offset)]
        case .centerOffset(let offset):
            return [centerYOffset(other, constant: offset)]
        case .end(let offset):
            return [bottomOffset(other, constant: -offset)]
        case .fill(let top, let bottom):
            return [
                topOffset(other, constant: top),
                bottomOffset(other, constant: -bottom)
            ]
        }
    }
}
