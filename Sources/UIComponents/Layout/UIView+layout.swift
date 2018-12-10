////
////  UIView+layout.swift
////  ZiWoYou
////
////  Created by ZJaDe on 16/10/15.
////  Copyright © 2016 Z_JaDe. All rights reserved.
////

import UIKit
import SnapKit

extension UIViewController {
    public func edgesToVC(_ viewController: UIViewController) {
        if self.parent == nil {
            viewController.addChild(self)
        }
        if self.view.superview == nil {
            viewController.view.addSubview(self.view)
        }
        self.view.edgesToVC(viewController)
    }
}
extension UIView {
    public func edgesToVC(_ viewController: UIViewController) {
        if self.superview == nil {
            viewController.view.addSubview(self)
        }
        self.snp.makeConstraints { (maker) in
            maker.margins.equalTo(viewController.view)
        }
    }
    public func edgesToSuper() {
        self.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
