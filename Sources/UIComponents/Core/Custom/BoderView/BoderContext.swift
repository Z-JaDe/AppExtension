//
//  BoderContext.swift
//  UIComponents
//
//  Created by ZJaDe on 2018/12/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CocoaExtension

public struct BoderContext {
    public enum Direction: Hashable, CaseIterable {
        case top
        case left
        case bottom
        case right
    }
    public enum BoderExcludePoint {
        case startPoint(CGFloat)
        case endPoint(CGFloat)
        case allPoint(CGFloat)
    }
    private var view: UIView?
    init(in view: UIView) {
        self.view = view
    }
    var directions: [Direction] = []
    var boderWidth: CGFloat = jd.onePx
    var boderColor: UIColor = Color.boderLine
    var edgeType: BoderExcludePoint = .allPoint(0)
    var fixedLength: CGFloat?
    var lineType: LineType = .solid
}
public extension BoderContext {
    private func finalize() {
        self.view!.boderView.update(with: self)
    }
    internal func cleanViewReference() -> BoderContext {
        self.then({$0.view = nil})
    }
    func lineAxis(_ direction: Direction) -> LineAxis {
        switch direction {
        case .left, .right:
            return .vertical
        case .top, .bottom:
            return .horizontal
        }
    }
    func then(_ closure: (inout BoderContext) -> Void) -> BoderContext {
        var copy = self
        closure(&copy)
        return copy
    }
}
public extension BoderContext {
    func width(_ width: CGFloat) -> BoderContext {
        self.then({$0.boderWidth = width.toPositiveNumber})
    }
    func color(_ color: UIColor) -> BoderContext {
        self.then({$0.boderColor = color})
    }
    func lineType(_ lineType: LineType) -> BoderContext {
        self.then({$0.lineType = lineType})
    }
    func edgeType(_ type: BoderExcludePoint) -> BoderContext {
        self.then({$0.edgeType = type})
    }
    func fixedLength(_ value: CGFloat?) -> BoderContext {
        self.then({$0.fixedLength = value?.toPositiveNumber})
    }
}
public extension BoderContext {
    func addTop() {
        self.add(.top)
    }
    func addLeft() {
        self.add(.left)
    }
    func addBottom() {
        self.add(.bottom)
    }
    func addRight() {
        self.add(.right)
    }
    func add() {
        self.add(Direction.allCases)
    }
    func add(_ directions: Direction...) {
        self.add(directions)
    }
    func add(_ directions: [Direction]) {
        self.then({$0.directions = directions}).finalize()
    }
}
extension UIView {
    public var boder: BoderContext {
        BoderContext(in: self)
    }
}
