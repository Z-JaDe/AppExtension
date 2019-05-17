//
//  PanReversibleAnimationTransition.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/28.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
open class PanReversibleAnimationTransition: ReversibleAnimationTransition {
    var tempFromView: UIView?
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        super.animateTransition(using: transitionContext)
        transitionContext.addViews()
        let containerView = transitionContext.containerView
        let tempFromView = transitionContext.addTempFromView()
        self.tempFromView = tempFromView
        let toView = transitionContext.toView

        // MARK: -
        self.isReverse ?
            containerView.sendSubviewToBack(toView) :
            containerView.bringSubviewToFront(toView)

        guard self.transitionState == .未开始 || self.transitionState == .已重设 else {
            transitionContext.setFinal(tempFromView, self.isReverse)
            completeHandle(using: transitionContext, tempFromView, false)
            self.transitionState = .已重设
            return
        }
        self.transitionState = .进行中
        transitionContext.setInitial(tempFromView, self.isReverse)
        let duration = self.transitionDuration(using: transitionContext)

        let animater = Animater().duration(duration).animations {
            transitionContext.setFinal(tempFromView, self.isReverse)
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
                    transitionContext.setInitial(tempFromView, self.isReverse)
                } else {
                    transitionContext.setFinal(tempFromView, self.isReverse)
                }
                }.completion({ (_) in
                    self.completeHandle(using: transitionContext, tempFromView, isCancelled)
                }).animate()
        } else {
            self.completeHandle(using: transitionContext, tempFromView, isCancelled)
        }
    }
    func completeHandle(using transitionContext: UIViewControllerContextTransitioning, _ tempFromView: UIView, _ isCancelled: Bool) {
        if self.tempFromView == tempFromView {
            tempFromView.removeFromSuperview()
        }
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
        let screenshotsView: UIView = fromView//fromView.window ?? fromView
        let view = UIImageView(image: screenshotsView.toImage())
        view.frame = initialFrame(for: fromVC)
        containerView.addSubview(view)
        return view
    }
    func setInitial(_ tempFromView: UIView, _ isReverse: Bool) {
        if fromView != tempFromView {
            fromView.isHidden = true
        }
        tempFromView.frame.origin.x = 0
        tempFromView.alpha = 1
        toView.frame.origin.x = isReverse ? -toWidth/2 : toWidth
    }
    func setFinal(_ tempFromView: UIView, _ isReverse: Bool) {
        tempFromView.frame.origin.x = isReverse ? fromWidth : -fromWidth/2
        tempFromView.alpha = 0
        toView.frame.origin.x = 0
    }
    fileprivate func _completeHandle(_ isCancelled: Bool) {
        fromView.isHidden = false
        completeTransition(!isCancelled)
    }
}
extension UIView {
    func toImage() -> UIImage {
        return UIGraphicsImageRenderer(bounds: self.bounds).image(actions: { (context) in
            drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        })
    }
}
