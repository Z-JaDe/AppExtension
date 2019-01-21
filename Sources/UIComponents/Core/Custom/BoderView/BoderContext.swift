//
//  BoderContext.swift
//  UIComponents
//
//  Created by 郑军铎 on 2018/12/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

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
        return self.then({$0.view = nil})
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
        return self.then({$0.boderWidth = width.toPositiveNumber})
    }
    func color(_ color: UIColor) -> BoderContext {
        return self.then({$0.boderColor = color})
    }
    func lineType(_ lineType: LineType) -> BoderContext {
        return self.then({$0.lineType = lineType})
    }
    func edgeType(_ type: BoderExcludePoint) -> BoderContext {
        return self.then({$0.edgeType = type})
    }
    func fixedLength(_ value: CGFloat?) -> BoderContext {
        return self.then({$0.fixedLength = value?.toPositiveNumber})
    }
}
public extension BoderContext {
    func addTop() {
        return self.add(.top)
    }
    func addLeft() {
        return self.add(.left)
    }
    func addBottom() {
        return self.add(.bottom)
    }
    func addRight() {
        return self.add(.right)
    }
    func add() {
        return self.add(Direction.allCases)
    }
    func add(_ directions: Direction...) {
        return self.add(directions)
    }
    func add(_ directions: [Direction]) {
        return self.then({$0.directions = directions}).finalize()
    }
}
extension UIView {
    public var boder: BoderContext {
        return BoderContext(in: self)
    }
}
