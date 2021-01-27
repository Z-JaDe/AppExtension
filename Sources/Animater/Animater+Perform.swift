//
//  Animater+Perform.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/15.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension Animater {

    public static var defaultSpringDamping: CGFloat = 0.8
    public static var defaultSpringVelocity: CGFloat = 10
    // MARK: - spring
    public func spring(dampingRatio: CGFloat = Animater.defaultSpringDamping, velocity: CGFloat = Animater.defaultSpringVelocity) {
        guard let animationsClosure = self.animationsClosure else {
            return
        }
        UIView.animate(
            withDuration: self.duration,
            delay: self.delay,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: velocity,
            options: self.options ?? .allowAnimatedContent,
            animations: animationsClosure,
            completion: self.completionClosure
        )
    }
    // MARK: - animate
    public func animate() {
        guard let animationsClosure = self.animationsClosure else {
            return
        }
        UIView.animate(withDuration: self.duration, delay: self.delay, options: self.options ?? [], animations: animationsClosure, completion: self.completionClosure)
    }
    public func noAnimate(_ completion: Bool) {
        guard let animationsClosure = self.animationsClosure else {
            return
        }
        animationsClosure()
        completionClosure?(completion)
    }
    // MARK: - transition
    public func transition(with view: UIView) {
        guard let animationsClosure = self.animationsClosure else {
            return
        }
        UIView.transition(with: view, duration: self.duration, options: self.options ?? .transitionCrossDissolve, animations: animationsClosure, completion: self.completionClosure)
    }

    // MARK: - shake
    public func shake(in view: UIView, _ times: Int = 5, shakeDirection: ShakeDirection = .horizontal) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        switch shakeDirection {
        case .horizontal:
            anim.values = [
                NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
                NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))]
        case .vertical:
            anim.values = [
                NSValue(caTransform3D: CATransform3DMakeTranslation( 0, -5, 0 )),
                NSValue(caTransform3D: CATransform3DMakeTranslation( 0, 5, 0 ))]
        }
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 0.03

        view.layer.add(anim, forKey: nil)
    }
}
