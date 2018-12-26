//
//  LineLayer.swift
//  UIComponents
//
//  Created by 郑军铎 on 2018/12/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public enum LineType {
    /// ZJaDe: 虚线
    case dotted(width: Int, space: Int)
    /// ZJaDe: 实线
    case solid
}
public enum LineAxis {
    case horizontal
    case vertical
}
public class LineLayer: CAShapeLayer {
    public override init() {
        super.init()
        self.fillColor = Color.clear.cgColor
        self.lineJoin = .round
    }
    public override init(layer: Any) {
        super.init(layer: layer)
        self.fillColor = Color.clear.cgColor
        self.lineJoin = .round
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open var lineColor: UIColor? = Color.boderLine {
        didSet { super.strokeColor = self.lineColor?.cgColor }
    }
    open var lineType: LineType = .solid {
        didSet { updateLineType() }
    }
    /// ZJaDe: 虚线情况下需要知道是水平的还是竖直的
    open var lineAxis: LineAxis = .horizontal {
        didSet { setNeedsLayout() }
    }
    // MARK: -
    @available(*, unavailable, message: "使用lineColor")
    open override var backgroundColor: CGColor? {
        get {return super.strokeColor}
        set {super.strokeColor = newValue}
    }
    @available(*, unavailable, message: "使用lineColor")
    open override var strokeColor: CGColor? {
        get {return super.strokeColor}
        set {super.strokeColor = newValue}
    }
    // MARK: -
    public override func layoutSublayers() {
        super.layoutSublayers()
        self.lineWidth = self.lineAxis == .horizontal ? self.height : self.width
        let path = CGMutablePath()
        switch self.lineAxis {
        case .horizontal:
            path.move(to: CGPoint(x: 0, y: self.height/2))
            path.addLine(to: CGPoint(x: self.width, y: self.height/2))
        case .vertical:
            path.move(to: CGPoint(x: self.width/2, y: 0))
            path.addLine(to: CGPoint(x: self.width/2, y: self.height))
        }
        self.path = path
    }
    func updateLineType() {
        switch self.lineType {
        case .dotted(width: let width, space: let space):
            self.lineDashPattern = [NSNumber(value: width), NSNumber(value: space)]
        case .solid:
            self.lineDashPattern = nil
        }
    }
}
