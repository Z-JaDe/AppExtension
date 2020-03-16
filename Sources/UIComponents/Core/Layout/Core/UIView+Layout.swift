//
//  UIView+layout.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/10/15.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

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
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint.equal(item: self, toItem: viewController.view, attribute: .leftMargin),
            NSLayoutConstraint.equal(item: self, toItem: viewController.view, attribute: .rightMargin),
            NSLayoutConstraint.equal(item: self, toItem: viewController.view, attribute: .topMargin),
            NSLayoutConstraint.equal(item: self, toItem: viewController.view, attribute: .bottomMargin)
            ])
    }
    public func edgesToSuper() {
        NSLayoutConstraint.activate(self.equalToSuperview(.edges))
    }
}
