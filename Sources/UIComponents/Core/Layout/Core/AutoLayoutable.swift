//
//  AutoLayoutable.swift
//  UIComponents
//
//  Created by Apple on 2019/12/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol AutoLayoutable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}
extension AutoLayoutable {
    func prepare() {
        if let owningView = self as? UIView, owningView.translatesAutoresizingMaskIntoConstraints {
            owningView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
extension UIView: AutoLayoutable {}
extension UILayoutGuide: AutoLayoutable {}
