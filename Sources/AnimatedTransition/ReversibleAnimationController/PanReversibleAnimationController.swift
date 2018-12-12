//
//  PanReversibleAnimationController.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/28.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
open class PanReversibleAnimationController: ReversibleAnimationController {
    open override func canUse() -> Bool {
        return true
    }
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        transitionContext.addViews()
        let containerView = transitionContext.containerView
        let tempFromView = transitionContext.addTempFromView()
        let toView = transitionContext.toView

        // MARK: -
        self.reverse ?
            containerView.sendSubviewToBack(toView) :
            containerView.bringSubviewToFront(toView)

        guard self.transitionState == .未开始 || self.transitionState == .已重设 else {
            transitionContext.setFinal(tempFromView, isReverse: self.reverse)
            completeHandle(using: transitionContext, tempFromView, false)
            self.transitionState = .已重设
            return
        }
        self.transitionState = .进行中
        transitionContext.setInitial(tempFromView, isReverse: self.reverse)
        let duration = self.transitionDuration(using: transitionContext)

        let animater = Animater().duration(duration).animations {
            transitionContext.setFinal(tempFromView, isReverse: self.reverse)
        }.completion({ (_) in
            self.complete(using: transitionContext, tempFromView)
        })
        transitionContext.isInteractive ?
            animater.animate() :
            animater.spring(dampingRatio: 0.95)
    }
    func complete(using transitionContext: UIViewControllerContextTransitioning, _ tempFromView: UIView) {
        guard self.transitionState == .进行中 else { return }
        let isCancelled = transitionContext.transitionWasCancelled
        if transitionContext.isInteractive {
            Animater().duration(duration / 2).animations {
                if isCancelled {
                    transitionContext.setInitial(tempFromView, isReverse: self.reverse)
                } else {
                    transitionContext.setFinal(tempFromView, isReverse: self.reverse)
                }
                }.completion({ (_) in
                    self.completeHandle(using: transitionContext, tempFromView, isCancelled)
                }).animate()
        } else {
            self.completeHandle(using: transitionContext, tempFromView, isCancelled)
        }
    }
    func completeHandle(using transitionContext: UIViewControllerContextTransitioning, _ tempFromView: UIView, _ isCancelled: Bool) {
        tempFromView.removeFromSuperview()
        transitionContext._completeHandle(isCancelled)
        self.transitionState = .未开始
    }
}
extension UIViewControllerContextTransitioning {
    func addViews() {
        containerView.addSubview(toView)
        if toView.superview == nil {
            fromView.superview?.addSubview(toView)
        }
    }
    func addTempFromView() -> UIView {
        let view = UIImageView(image: fromView.toImage())
        view.frame = initialFrame(for: fromVC)
        containerView.addSubview(view)
        return view
    }
    func setInitial(_ tempFromView: UIView, isReverse: Bool) {
        fromView.isHidden = true
        tempFromView.frame.origin.x = 0
        tempFromView.alpha = 1
        toView.frame.origin.x = isReverse ? -toWidth/2 : toWidth
    }
    func setFinal(_ tempFromView: UIView, isReverse: Bool) {
        tempFromView.frame.origin.x = isReverse ? fromWidth : -fromWidth/2
        tempFromView.alpha = 0
        toView.frame.origin.x = 0
    }
    fileprivate func _completeHandle(_ isCancelled: Bool) {
        fromView.isHidden = false
        if isCancelled {
            toView.removeFromSuperview()
        } else {
            fromView.removeFromSuperview()
        }
        completeTransition(!isCancelled)
    }
}
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, self.layer.contentsScale)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
