//
//  GradientView.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/19.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "废弃 使用UIImage扩展")
public class GradientView: CustomView {

    public var gradientLayer: CAGradientLayer {
        // swiftlint:disable force_cast
        return self.layer as! CAGradientLayer
    }
    open override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    public enum Direction {
        case topToBottom
        case bottomToTop
        case leftToRight
        case rightToLeft
    }
    @discardableResult
    public func config(_ direction: Direction, _ colors: UIColor...) -> Self {
        config(direction, colors)
    }
    @discardableResult
    public func config(_ direction: Direction, _ colors: [UIColor]) -> Self {
        self.gradientLayer.colors = colors.map({$0.cgColor})
        self.gradientLayer.locations = colors.enumerated().map({$0.offset.double / (colors.count - 1).double}).map(NSNumber.init)
        switch direction {
        case .topToBottom:
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .bottomToTop:
            self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        case .leftToRight:
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .rightToLeft:
            self.gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            self.gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        }
        return self
    }

    public func finalizeImage() -> UIImage {
        self.layer.toImage()
    }
}
