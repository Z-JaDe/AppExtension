//
//  CycleProgress.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/23.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

open class CycleProgress: CustomView {
    let percentCircleLayer: CAShapeLayer = CAShapeLayer()
    let backCircleLayer: CAShapeLayer = CAShapeLayer()
    public var lineWidth: CGFloat = 2 {
        didSet {update()}
    }
    public var strokeStart: CGFloat {
        get {return self.percentCircleLayer.strokeStart}
        set {self.percentCircleLayer.strokeStart = newValue}
    }
    public var strokeEnd: CGFloat {
        get {return self.percentCircleLayer.strokeEnd}
        set {self.percentCircleLayer.strokeEnd = newValue}
    }
    public var lineColor: CGColor? {
        get {return self.percentCircleLayer.strokeColor}
        set {self.percentCircleLayer.strokeColor = newValue}
    }
    public var backColor: CGColor? {
        get {return self.backCircleLayer.strokeColor}
        set {self.backCircleLayer.strokeColor = newValue}
    }
    open override func configInit() {
        super.configInit()
        self.backCircleLayer.fillColor = Color.clear.cgColor
        self.layer.addSublayer(self.backCircleLayer)
        self.percentCircleLayer.fillColor = Color.clear.cgColor
        self.layer.addSublayer(self.percentCircleLayer)
        self.percentCircleLayer.lineCap = .round

        self.lineColor = Color.tintColor.cgColor
        self.backColor = Color.lightGray.cgColor
        self.backgroundColor = Color.clear
        update()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.update()
    }

    func update() {
        let rect = self.bounds
        let radius = min(rect.size.width / 2, rect.size.height / 2)
        let arcCenter = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: -CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)

        self.percentCircleLayer.lineWidth = self.lineWidth
        self.backCircleLayer.lineWidth = self.lineWidth
        self.percentCircleLayer.path = path.cgPath
        self.backCircleLayer.path = path.cgPath
    }

}
