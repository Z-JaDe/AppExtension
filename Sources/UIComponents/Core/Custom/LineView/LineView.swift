//
//  LineView.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/10/10.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

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

open class LineView: CustomView {
    open var lineHeight: CGFloat = 1 {
        didSet {invalidateIntrinsicContentSize()}
    }
    open var lineType: LineType {
        get {
            if dottedWidth == nil || dottedSpace == nil {
                return .solid
            } else {
                return .dotted(width: dottedWidth!, space: dottedSpace!)
            }
        }
        set {
            switch newValue {
            case .dotted(width: let width, space: let space):
                dottedWidth = width
                dottedSpace = space
            case .solid:
                dottedWidth = nil
                dottedSpace = nil
            }
        }
    }
    open var lineAxis: LineAxis = .horizontal {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    open var lineColor: UIColor? = Color.boderLine {
        didSet {
            self.setNeedsLayout()
        }
    }

    open var dottedWidth: Int?
    open var dottedSpace: Int?

    open override var backgroundColor: UIColor? {
        get {return self.lineColor}
        set {self.lineColor = newValue}
    }
    open class func dotted(lineAxis: LineAxis) -> Self {
        return self.init(lineType: .dotted(width: 10, space: 3), lineAxis: lineAxis)
    }
    open class func solid(lineAxis: LineAxis) -> Self {
        return self.init(lineType: .solid, lineAxis: lineAxis)
    }
    public convenience required init(lineType: LineType = .dotted(width: 3, space: 1), lineAxis: LineAxis = .horizontal) {
        self.init(frame: CGRect())
        self.lineType = lineType
        self.lineAxis = lineAxis
    }

    open override func configInit() {
        super.configInit()
        self.layer.masksToBounds = true
        self.layer.addSublayer(self.shapeLayer)
        self.contentPriority(.defaultLow)
    }
    // MARK: -
    open var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = Color.clear.cgColor
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        return shapeLayer
    }()
    open override var intrinsicContentSize: CGSize {
        switch self.lineAxis {
        case .horizontal:
            return CGSize(width: 1234, height: self.lineHeight)
        case .vertical:
            return CGSize(width: self.lineHeight, height: 1234)
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.shapeLayer.frame = self.bounds
        self.shapeLayer.strokeColor = self.lineColor?.cgColor
        switch self.lineType {
        case .dotted(width: let width, space: let space):
            self.shapeLayer.lineDashPattern = [NSNumber(value: width), NSNumber(value: space)]
        case .solid:
            self.shapeLayer.lineDashPattern = nil
        }
        self.shapeLayer.lineWidth = self.lineAxis == .horizontal ? self.height : self.width
        let path = CGMutablePath()
        switch self.lineAxis {
        case .horizontal:
            path.move(to: CGPoint(x: 0, y: self.height/2))
            path.addLine(to: CGPoint(x: self.right, y: self.height/2))
        case .vertical:
            path.move(to: CGPoint(x: self.width/2, y: 0))
            path.addLine(to: CGPoint(x: self.width/2, y: self.bottom))
        }
        self.shapeLayer.path = path
    }

}
