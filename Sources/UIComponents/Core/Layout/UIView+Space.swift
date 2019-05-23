//
//  UIView+Space.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import UIKit

extension UIView {
    public func topSpace(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
    }
    public func bottomSpace(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant)
    }
    public func leftSpace(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.leftAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
    }
    public func rightSpace(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.rightAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
    }
}
extension UIView {
    public func topOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
    }
    public func bottomOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
    }
    public func leftOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
    }
    public func rightOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
    }
    public func centerXOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
    }
    public func centerYOffset(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        return self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
    }
}
