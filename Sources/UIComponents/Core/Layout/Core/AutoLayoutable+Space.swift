//
//  UIView+Space.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import UIKit

extension AutoLayoutable {
    public func topSpace(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
    }
    public func bottomSpace(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant)
    }
    public func leftSpace(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return leftAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
    }
    public func rightSpace(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return rightAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
    }
}
extension AutoLayoutable {
    public func topOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
    }
    public func bottomOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
    }
    public func leftOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
    }
    public func rightOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return rightAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
    }
    public func centerXOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
    }
    public func centerYOffset(_ view: AutoLayoutable, constant: CGFloat = 0) -> NSLayoutConstraint {
        prepare()
        return centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
    }
}
