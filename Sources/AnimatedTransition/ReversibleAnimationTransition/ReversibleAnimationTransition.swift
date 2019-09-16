//
//  ReversibleAnimationTransition.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
open class ReversibleAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransitionState {
        case 未开始
        case 进行中
        case 已重设
    }
    var transitionState: TransitionState = .未开始
    // MARK: - 
    public private(set) var isReverse: Bool
    public var duration: TimeInterval = 0.75
    public init(isReverse: Bool) {
        self.isReverse = isReverse
        super.init()
    }

    public var animateTransitionClosure: ((UIViewControllerContextTransitioning) -> Void)?

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.animateTransitionClosure?(transitionContext)
    }
    public func animationEnded(_ transitionCompleted: Bool) {
    }
}
extension UIViewControllerContextTransitioning {
    var fromVC: UIViewController {
        viewController(forKey: .from)!
    }
    var toVC: UIViewController {
        viewController(forKey: .to)!
    }
    var fromView: UIView {
        view(forKey: .from)!
    }
    var toView: UIView {
        view(forKey: .to)!
    }
    var fromWidth: CGFloat {
        initialFrame(for: fromVC).size.width
    }
    var toWidth: CGFloat {
        finalFrame(for: toVC).size.width
    }
}
