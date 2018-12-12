//
//  UIView+Boder.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/10/10.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public enum BoderDirection {
    case top
    case left
    case bottom
    case right
}
private var topLineKey: UInt8 = 0
private var leftLineKey: UInt8 = 0
private var bottomLineKey: UInt8 = 0
private var rightLineKey: UInt8 = 0

public enum ExcludePoint: Int {
    case startPoint
    case endPoint
    case allPoint
}
extension UIView {
    /// ZJaDe: 添加top boder
    @discardableResult
    public func addBorderTop(boderWidth: CGFloat = 1, color: UIColor = Color.boderLine, padding: CGFloat = 0, fixedLength: CGFloat? = nil, edgeType: ExcludePoint = .allPoint, isDottedLine: Bool = false) -> LineView? {
        return self.addBorder(boderWidth: boderWidth, direction: .top, color: color, padding: padding, fixedLength: fixedLength, edgeType: edgeType, isDottedLine: isDottedLine)
    }
    /// ZJaDe: 添加bottom boder
    @discardableResult
    public func addBorderBottom(boderWidth: CGFloat = 1, color: UIColor = Color.boderLine, padding: CGFloat = 0, fixedLength: CGFloat? = nil, edgeType: ExcludePoint = .allPoint, isDottedLine: Bool = false) -> LineView? {
        return self.addBorder(boderWidth: boderWidth, direction: .bottom, color: color, padding: padding, fixedLength: fixedLength, edgeType: edgeType, isDottedLine: isDottedLine)
    }
    /// ZJaDe: 添加left boder
    @discardableResult
    public func addBorderLeft(boderWidth: CGFloat = 1, color: UIColor = Color.boderLine, padding: CGFloat = 0, fixedLength: CGFloat? = nil, edgeType: ExcludePoint = .allPoint, isDottedLine: Bool = false) -> LineView? {
        return self.addBorder(boderWidth: boderWidth, direction: .left, color: color, padding: padding, fixedLength: fixedLength, edgeType: edgeType, isDottedLine: isDottedLine)
    }
    /// ZJaDe: 添加right boder
    @discardableResult
    public func addBorderRight(boderWidth: CGFloat = 1, color: UIColor = Color.boderLine, padding: CGFloat = 0, fixedLength: CGFloat? = nil, edgeType: ExcludePoint = .allPoint, isDottedLine: Bool = false) -> LineView? {
        return self.addBorder(boderWidth: boderWidth, direction: .right, color: color, padding: padding, fixedLength: fixedLength, edgeType: edgeType, isDottedLine: isDottedLine)
    }
    /// ZJaDe: 添加boder
    public func addDottedBorder() {
        self.addBorderTop(isDottedLine: true)
        self.addBorderBottom(isDottedLine: true)
        self.addBorderLeft(isDottedLine: true)
        self.addBorderRight(isDottedLine: true)
    }
    // MARK: -
    /// ZJaDe: fixedLength 不为空时，padding无效
    private func addBorder(boderWidth: CGFloat, direction: BoderDirection, color: UIColor, padding: CGFloat, fixedLength: CGFloat?, edgeType: ExcludePoint, isDottedLine: Bool) -> LineView? {
        var border: LineView! = {
            switch direction {
            case .top:
                return associatedObject(&topLineKey)
            case .left:
                return associatedObject(&leftLineKey)
            case .bottom:
                return associatedObject(&bottomLineKey)
            case .right:
                return associatedObject(&rightLineKey)
            }
        }()
        guard boderWidth > 0 else {
            border?.removeFromSuperview()
            return nil
        }
        if border == nil {
            let lineAxis: LineAxis
            switch direction {
            case .left, .right:
                lineAxis = .vertical
            case .top, .bottom:
                lineAxis = .horizontal
            }
            if isDottedLine {
                border = LineView.dotted(lineAxis: lineAxis)
            } else {
                border = LineView.solid(lineAxis: lineAxis)
            }
            border.isUserInteractionEnabled = false
            switch direction {
            case .top:
                setAssociatedObject(&topLineKey, border)
            case .left:
                setAssociatedObject(&leftLineKey, border)
            case .bottom:
                setAssociatedObject(&bottomLineKey, border)
            case .right:
                setAssociatedObject(&rightLineKey, border)
            }
        } else {
            border.removeFromSuperview()
        }
        self.insertSubview(border, at: 0)
        border.lineColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        /*************** layout ***************/
        var startPadding: CGFloat = 0
        var endPadding: CGFloat = 0
        if fixedLength == nil {
            switch edgeType {
            case .startPoint, .allPoint:
                startPadding += padding
                if edgeType == .allPoint {
                    fallthrough
                }
            case .endPoint:
                endPadding += padding
            }
        }
        func addBoderConstraint(attr attr1: NSLayoutConstraint.Attribute, toItem: UIView?, attr attr2: NSLayoutConstraint.Attribute, constant: CGFloat) {
            self.addConstraint(NSLayoutConstraint(item: border, attribute: attr1, relatedBy: .equal, toItem: toItem, attribute: attr2, multiplier: 1, constant: constant))
        }
        switch direction {
        case .top, .bottom:
            if fixedLength == nil {
                addBoderConstraint(attr: .left, toItem: self, attr: .left, constant: startPadding)
                addBoderConstraint(attr: .right, toItem: self, attr: .right, constant: -endPadding)
            } else {
                addBoderConstraint(attr: .width, toItem: nil, attr: .notAnAttribute, constant: fixedLength!)
                addBoderConstraint(attr: .centerX, toItem: self, attr: .centerX, constant: 0)
            }
            addBoderConstraint(attr: .height, toItem: nil, attr: .notAnAttribute, constant: boderWidth)
            if direction == .top {
                addBoderConstraint(attr: .top, toItem: self, attr: .top, constant: 0)
            } else {
                addBoderConstraint(attr: .bottom, toItem: self, attr: .bottom, constant: 0)
            }
        case .left, .right:
            if fixedLength == nil {
                addBoderConstraint(attr: .top, toItem: self, attr: .top, constant: startPadding)
                addBoderConstraint(attr: .bottom, toItem: self, attr: .bottom, constant: -endPadding)
            } else {
                addBoderConstraint(attr: .height, toItem: nil, attr: .notAnAttribute, constant: fixedLength!)
                addBoderConstraint(attr: .centerY, toItem: self, attr: .centerY, constant: 0)
            }
            addBoderConstraint(attr: .width, toItem: nil, attr: .notAnAttribute, constant: boderWidth)
            if direction == .left {
                addBoderConstraint(attr: .left, toItem: self, attr: .left, constant: 0)
            } else {
                addBoderConstraint(attr: .right, toItem: self, attr: .right, constant: 0)
            }
        }
        return border
    }
}
