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
    public func horizontal(_ other: UIView, _ position: LayoutOptions) -> [NSLayoutConstraint] {
        switch position {
        case .start(let offset):
            return [self.leftOffset(other, constant: offset)]
        case .centerOffset(let offset):
            return [self.centerXOffset(other, constant: offset)]
        case .end(let offset):
            return [self.rightOffset(other, constant: -offset)]
        case .fill(let left, let right):
            return [
                self.leftOffset(other, constant: left),
                self.rightOffset(other, constant: -right)
            ]
        }
    }
    public func vertical(_ other: UIView, _ position: LayoutOptions) -> [NSLayoutConstraint] {
        switch position {
        case .start(let offset):
            return [self.topOffset(other, constant: offset)]
        case .centerOffset(let offset):
            return [self.centerYOffset(other, constant: offset)]
        case .end(let offset):
            return [self.bottomOffset(other, constant: -offset)]
        case .fill(let top, let bottom):
            return [
                self.topOffset(other, constant: top),
                self.bottomOffset(other, constant: -bottom)
            ]
        }
    }
}
