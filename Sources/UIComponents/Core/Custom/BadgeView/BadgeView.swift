//
//  BadgeView.swift
//  JDAnimatedTabBarDemo
//
//  Created by Alex K. on 17/12/15.
//  Copyright © 2015 Ramotion. All rights reserved.
//

import UIKit

public class BadgeView: UILabel {

    internal var topConstraint: NSLayoutConstraint?
    internal var centerXConstraint: NSLayoutConstraint?

    open class func badge() -> BadgeView {
        return BadgeView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        layer.backgroundColor = Color.red.cgColor
        layer.cornerRadius = frame.size.width / 2

        configureNumberLabel()

        translatesAutoresizingMaskIntoConstraints = false

        // constraints
        createSizeConstraints(frame.size)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    // PRAGMA: create

    internal func createSizeConstraints(_ size: CGSize) {
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: size.width)
        self.addConstraint(widthConstraint)

        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: size.height)
        self.addConstraint(heightConstraint)
    }

    fileprivate func configureNumberLabel() {
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 13)
        textColor = Color.white
    }

    // PRAGMA: helpers

    open func addBadgeOnView(_ onView: UIView) {

        onView.addSubview(self)

        // create constraints
        topConstraint = NSLayoutConstraint(item: self,
            attribute: NSLayoutConstraint.Attribute.top,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: onView,
            attribute: NSLayoutConstraint.Attribute.top,
            multiplier: 1,
            constant: 3)
        onView.addConstraint(topConstraint!)

        centerXConstraint = NSLayoutConstraint(item: self,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: onView,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 10)
        onView.addConstraint(centerXConstraint!)
    }
}
