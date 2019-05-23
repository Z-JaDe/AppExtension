//
//  BoderView.swift
//  UIComponents
//
//  Created by 郑军铎 on 2018/12/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
class BoderView: CustomView {
    typealias LineLayerType = LineLayer
    private lazy var topLayer: LineLayerType = createLayer()
    private lazy var leftLayer: LineLayerType = createLayer()
    private lazy var bottomLayer: LineLayerType = createLayer()
    private lazy var rightLayer: LineLayerType = createLayer()
    public typealias Direction = BoderContext.Direction
    private var data: [Direction: BoderContext] = [:]
    override func configInit() {
        super.configInit()
        self.isUserInteractionEnabled = false
        self.backgroundColor = Color.clear
    }
    // MARK: -
    func update(with context: BoderContext) {
        for direction in context.directions {
            self.data[direction] = context.cleanViewReference()
        }
        setNeedsLayout()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for (direction, context) in data {
            update(direction: direction, context: context)
        }
    }
    // MARK: -
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        return result
    }
}

extension BoderView {
    internal func getLayer(in direction: Direction) -> LineLayerType {
        switch direction {
        case .top: return self.topLayer
        case .left: return self.leftLayer
        case .bottom: return self.bottomLayer
        case .right: return self.rightLayer
        }
    }
    func createLayer() -> LineLayerType {
        let result = LineLayerType()
        self.layer.addSublayer(result)
        return result
    }
}
private var boderViewKey: UInt8 = 0
extension UIView {
    var boderView: BoderView {
        return associatedObject(&boderViewKey, createIfNeed: BoderView().then({ (boderView) in
            self.insertSubview(boderView, at: 0)
            boderView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                boderView.centerXOffset(self),
                boderView.centerYOffset(self),
                boderView.topOffset(self),
                boderView.leftOffset(self)
                ])
        }))
    }
}
