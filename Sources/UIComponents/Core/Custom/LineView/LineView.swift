//
//  LineView.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/10/10.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
open class LineView: CustomView {
    open var lineHeight: CGFloat = 1 {
        didSet { invalidateIntrinsicContentSize() }
    }
    public let lineLayer: LineLayer = LineLayer()
    open var lineAxis: LineAxis {
        get { self.lineLayer.lineAxis }
        set { self.lineLayer.lineAxis = newValue
            invalidateIntrinsicContentSize()
        }
    }
    open var lineType: LineType {
        get { self.lineLayer.lineType }
        set { self.lineLayer.lineType = newValue }
    }
    open var lineColor: UIColor? {
        get { self.lineLayer.lineColor }
        set { self.lineLayer.lineColor = newValue }
    }

    @available(*, deprecated, message: "使用lineColor")
    open override var backgroundColor: UIColor? {
        get {return self.lineColor}
        set {self.lineColor = newValue}
    }
    open class func dotted(lineAxis: LineAxis) -> Self {
        self.init(lineType: .dotted(width: 10, space: 3), lineAxis: lineAxis)
    }
    open class func solid(lineAxis: LineAxis) -> Self {
        self.init(lineType: .solid, lineAxis: lineAxis)
    }
    public convenience required init(lineType: LineType, lineAxis: LineAxis = .horizontal) {
        self.init(frame: CGRect())
        self.lineType = lineType
        self.lineAxis = lineAxis
    }

    open override func configInit() {
        super.configInit()
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = true
        self.layer.addSublayer(self.lineLayer)
        self.contentPriority(.defaultLow)
    }
    // MARK: -
    open override var intrinsicContentSize: CGSize {
        switch self.lineAxis {
        case .horizontal:
            return CGSize(width: UIView.noIntrinsicMetric, height: self.lineHeight)
        case .vertical:
            return CGSize(width: self.lineHeight, height: UIView.noIntrinsicMetric)
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.lineLayer.frame = self.bounds
    }
}
