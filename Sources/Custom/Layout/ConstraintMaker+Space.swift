////
////  ConstraintMaker.swift
////  ZiWoYou
////
////  Created by Z_JaDe on 2016/10/24.
////  Copyright © 2016 Z_JaDe. All rights reserved.
////
import UIKit
import SnapKit

extension UIView {
    public func width_height(scale: CGFloat) {
        self.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.snp.height).multipliedBy(scale)
        }
    }
    public func height_width(scale: CGFloat) {
        self.snp.makeConstraints { (maker) in
            maker.height.equalTo(self.snp.width).multipliedBy(scale)
        }
    }
}
//extension ConstraintMaker {
//    /// ZJaDe: 宽比高
//    public func width_height(scale: CGFloat) {
//        if let view = self.item as? UIView {
//            self.width.equalTo(view.snp.height).multipliedBy(scale)
//        } else {
//            logError("item 非 UIView type")
//        }
//    }
//    /// ZJaDe: 高比宽
//    public func height_width(scale: CGFloat) {
//        if let view = self.item as? UIView {
//            self.height.equalTo(view.snp.width).multipliedBy(scale)
//        } else {
//            logError("item 非 UIView type")
//        }
//    }
//}
extension ConstraintMaker {
    @discardableResult
    public func topSpaceToVC(_ viewController: UIViewController) -> ConstraintMakerEditable {
        return self.top.equalTo(viewController.topLayoutGuide.snp.bottom)
    }
    @discardableResult
    public func bottomSpaceToVC(_ viewController: UIViewController) -> ConstraintMakerEditable {
        return self.bottom.equalTo(viewController.bottomLayoutGuide.snp.top)
    }
}
extension ConstraintMaker {
    @discardableResult
    public func topSpace(_ view: UIView) -> ConstraintMakerEditable {
        return self.top.equalTo(view.snp.bottom)
    }
    @discardableResult
    public func bottomSpace(_ view: UIView) -> ConstraintMakerEditable {
        return self.bottom.equalTo(view.snp.top)
    }
    @discardableResult
    public func leftSpace(_ view: UIView) -> ConstraintMakerEditable {
        return self.left.equalTo(view.snp.right)
    }
    @discardableResult
    public func rightSpace(_ view: UIView) -> ConstraintMakerEditable {
        return self.right.equalTo(view.snp.left)
    }
}
