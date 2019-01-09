//
//  BoderView+Context.swift
//  UIComponents
//
//  Created by 郑军铎 on 2018/12/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

extension BoderView {
    func update(direction: Direction, context: BoderContext) {
        let layer = getLayer(in: direction)
        layer.frame = calculateFrame(direction: direction, with: context)

        layer.lineColor = context.boderColor
        layer.lineType = context.lineType
    }
    private func calculateFrame(direction: Direction, with context: BoderContext) -> CGRect {
        var result = CGRect()
        let totalLength: CGFloat
        let length: CGFloat
        let boderWidth: CGFloat = context.boderWidth
        switch context.lineAxis(direction) {
        case .horizontal:
            totalLength = self.bounds.width
            length = calculateLength(with: context, totalLength).toPositiveNumber
            result.size.height = boderWidth
            result.size.width = length
            result.origin.x = calculatePositionOffset(with: context, totalLength, length)
        case .vertical:
            totalLength = self.bounds.height
            length = calculateLength(with: context, totalLength).toPositiveNumber
            result.size.width = boderWidth
            result.size.height = length
            result.origin.y = calculatePositionOffset(with: context, totalLength, length)
        }
        switch direction {
        case .top: result.origin.y = 0
        case .left: result.origin.x = 0
        case .bottom: result.origin.y = self.bounds.maxY - boderWidth
        case .right: result.origin.x = self.bounds.maxX - boderWidth
        }
        return result
    }
    private func calculateLength(with context: BoderContext, _ totalLength: CGFloat) -> CGFloat {
        if let length = context.fixedLength {
            return length
        } else {
            switch context.edgeType {
            case .allPoint(let padding):
                return totalLength - padding * 2
            case .startPoint(let padding):
                return totalLength - padding
            case .endPoint(let padding):
                return totalLength - padding
            }
        }
    }
    private func calculatePositionOffset(with context: BoderContext, _ totalLength: CGFloat, _ length: CGFloat) -> CGFloat {
        switch context.edgeType {
        case .allPoint:
            return (totalLength - length) / 2
        case .startPoint(let padding):
            return padding
        case .endPoint(let padding):
            return totalLength - padding - length
        }
    }
}
