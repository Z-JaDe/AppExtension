//
//  LineView.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/10/10.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
open class LineView: CustomView {
    open var lineHeight: CGFloat = 1 {
        didSet { invalidateIntrinsicContentSize() }
    }
    public let lineLayer: LineLayer = LineLayer()
    open var lineAxis: LineAxis {
        get { return self.lineLayer.lineAxis }
        set { self.lineLayer.lineAxis = newValue
            invalidateIntrinsicContentSize()
        }
    }
    open var lineType: LineType {
        get { return self.lineLayer.lineType }
        set { self.lineLayer.lineType = newValue }
    }
    open var lineColor: UIColor? {
        get { return self.lineLayer.lineColor }
        set { self.lineLayer.lineColor = newValue }
    }

    @available(*, deprecated, message: "使用lineColor")
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
            return CGSize(width: 1234, height: self.lineHeight)
        case .vertical:
            return CGSize(width: self.lineHeight, height: 1234)
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.lineLayer.frame = self.bounds
    }
}
