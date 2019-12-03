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
        snp.makeConstraints { (maker) in
            maker.width.equalTo(snp.height).multipliedBy(scale)
        }
    }
    public func height_width(scale: CGFloat) {
        snp.makeConstraints { (maker) in
            maker.height.equalTo(snp.width).multipliedBy(scale)
        }
    }
}
//extension ConstraintMaker {
//    /// ZJaDe: 宽比高
//    public func width_height(scale: CGFloat) {
//        if let view = item as? UIView {
//            width.equalTo(view.snp.height).multipliedBy(scale)
//        } else {
//            logError("item 非 UIView type")
//        }
//    }
//    /// ZJaDe: 高比宽
//    public func height_width(scale: CGFloat) {
//        if let view = item as? UIView {
//            height.equalTo(view.snp.width).multipliedBy(scale)
//        } else {
//            logError("item 非 UIView type")
//        }
//    }
//}
extension ConstraintMaker {
    @discardableResult
    public func topSpaceToVC(_ viewController: UIViewController) -> ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return top.equalTo(viewController.view.safeAreaLayoutGuide)
        } else {
            return top.equalTo(viewController.topLayoutGuide.snp.bottom)
        }
    }
    @discardableResult
    public func bottomSpaceToVC(_ viewController: UIViewController) -> ConstraintMakerEditable {
        if #available(iOS 11.0, *) {
            return bottom.equalTo(viewController.view.safeAreaLayoutGuide)
        } else {
            return bottom.equalTo(viewController.bottomLayoutGuide.snp.top)
        }
    }
}
extension ConstraintMaker {
    @discardableResult
    public func topSpace(_ view: UIView) -> ConstraintMakerEditable {
        top.equalTo(view.snp.bottom)
    }
    @discardableResult
    public func bottomSpace(_ view: UIView) -> ConstraintMakerEditable {
        bottom.equalTo(view.snp.top)
    }
    @discardableResult
    public func leftSpace(_ view: UIView) -> ConstraintMakerEditable {
        left.equalTo(view.snp.right)
    }
    @discardableResult
    public func rightSpace(_ view: UIView) -> ConstraintMakerEditable {
        right.equalTo(view.snp.left)
    }
}
