//
//  FilledPageControl.swift
//  PageControls
//
//  Created by Kyle Zaragoza on 8/6/16.
//  Copyright © 2016 Kyle Zaragoza. All rights reserved.
//

import UIKit

@IBDesignable open class FilledPageControl: UIView {

    // MARK: - PageControl

    @IBInspectable open var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            updateActivePageIndicatorMasks(forProgress: progress)
        }
    }
    open var currentPage: Int {
        Int(round(progress))
    }

    // MARK: - Appearance

    open override var tintColor: UIColor! {
        didSet {
            inactiveLayers.forEach { $0.backgroundColor = tintColor.cgColor }
        }
    }
    @IBInspectable open var inactiveRingWidth: CGFloat = 1 {
        didSet {
            updateActivePageIndicatorMasks(forProgress: progress)
        }
    }
    @IBInspectable open var indicatorPadding: CGFloat = 10 {
        didSet {
            layoutPageIndicators(inactiveLayers)
        }
    }
    @IBInspectable open var indicatorRadius: CGFloat = 5 {
        didSet {
            layoutPageIndicators(inactiveLayers)
        }
    }

    fileprivate var indicatorDiameter: CGFloat {
        indicatorRadius * 2
    }
    fileprivate var inactiveLayers = [CALayer]()

    // MARK: - State Update

    fileprivate func updateNumberOfPages(_ count: Int) {
        // no need to update
        guard count != inactiveLayers.count else { return }
        // reset current layout
        inactiveLayers.forEach { $0.removeFromSuperlayer() }
        inactiveLayers = [CALayer]()
        // add layers for new page count
        inactiveLayers = stride(from: 0, to: count, by: 1).map { _ in
            let layer = CALayer()
            layer.backgroundColor = self.tintColor.cgColor
            self.layer.addSublayer(layer)
            return layer
        }
        layoutPageIndicators(inactiveLayers)
        updateActivePageIndicatorMasks(forProgress: progress)
        self.invalidateIntrinsicContentSize()
    }

    // MARK: - Layout

    fileprivate func updateActivePageIndicatorMasks(forProgress progress: CGFloat) {
        // ignore if progress is outside of page indicators' bounds
        guard (0...CGFloat(pageCount - 1)).contains(progress) else { return }

        // mask rect w/ default stroke width
        let insetRect = CGRect(x: 0, y: 0, width: indicatorDiameter, height: indicatorDiameter).insetBy(dx: inactiveRingWidth, dy: inactiveRingWidth)
        let leftPageFloat = trunc(progress)
        let leftPageInt = Int(progress)

        // inset right moving page indicator
        let spaceToMove = insetRect.size.width / 2
        let percentPastLeftIndicator = progress - leftPageFloat
        let additionalSpaceToInsetRight = spaceToMove * percentPastLeftIndicator
        let closestRightInsetRect = insetRect.insetBy(dx: additionalSpaceToInsetRight, dy: additionalSpaceToInsetRight)

        // inset left moving page indicator
        let additionalSpaceToInsetLeft = (1 - percentPastLeftIndicator) * spaceToMove
        let closestLeftInsetRect = insetRect.insetBy(dx: additionalSpaceToInsetLeft, dy: additionalSpaceToInsetLeft)

        // adjust masks
        for (idx, layer) in inactiveLayers.enumerated() {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

            let boundsPath = UIBezierPath(rect: layer.bounds)
            let circlePath: UIBezierPath
            if leftPageInt == idx {
                circlePath = UIBezierPath(ovalIn: closestLeftInsetRect)
            } else if leftPageInt + 1 == idx {
                circlePath = UIBezierPath(ovalIn: closestRightInsetRect)
            } else {
                circlePath = UIBezierPath(ovalIn: insetRect)
            }
            boundsPath.append(circlePath)
            maskLayer.path = boundsPath.cgPath
            layer.mask = maskLayer
        }
    }

    fileprivate func layoutPageIndicators(_ layers: [CALayer]) {
        let layerDiameter = indicatorRadius * 2
        var layerFrame = CGRect(x: 0, y: 0, width: layerDiameter, height: layerDiameter)
        layers.forEach { layer in
            layer.cornerRadius = self.indicatorRadius
            layer.frame = layerFrame
            layerFrame.origin.x += layerDiameter + indicatorPadding
        }
    }

    open override var intrinsicContentSize: CGSize {
        sizeThatFits(CGSize.zero)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let layerDiameter = indicatorRadius * 2
        return CGSize(width: CGFloat(inactiveLayers.count) * layerDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding,
                      height: layerDiameter)
    }
}
