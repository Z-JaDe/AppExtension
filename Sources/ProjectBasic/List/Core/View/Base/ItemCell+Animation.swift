//
//  ItemCell+Animation.swift
//  AppExtension
//
//  Created by Apple on 2019/11/18.
//

import Foundation

public enum CellAppearAnimationType {
    case none
    case zoomZ
    case slideLeft
}
public enum CellHighlightedAnimationType {
    case none
    case zoom
}

extension UIView {
    open func configAppearAnimate(_ animationType: CellAppearAnimationType) {
        switch animationType {
        case .zoomZ:
            self.alpha = 0.95
            self.layer.transform = CATransform3DMakeScale(0.98, 0.98, 0)
            Animater().duration(0.5).animations {
                self.layer.transform = CATransform3DIdentity
                self.alpha = 1
                }.animate()
        case .slideLeft:
            self.alpha = 0.95
            self.layer.transform = CATransform3DMakeTranslation(-self.width, 0, 0)
            Animater().animations {
                self.alpha = 1
                self.layer.transform = CATransform3DIdentity
                }.animate()
        case .none: break
        }
    }
    open func configHighlightedAnimate(_ animationType: CellHighlightedAnimationType, _ isHighlighted: Bool) {
        switch animationType {
        case .zoom:
            Animater().animations {
                if isHighlighted {
                    self.layer.transform = CATransform3DMakeScale(1, 1, 0.97)
                } else {
                    self.layer.transform = CATransform3DIdentity
                }
            }.animate()
        case .none: break
        }
    }
}
