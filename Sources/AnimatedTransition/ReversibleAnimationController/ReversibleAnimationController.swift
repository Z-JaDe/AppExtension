//
//  ReversibleAnimationController.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
open class ReversibleAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
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
        return self.duration
    }
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.animateTransitionClosure?(transitionContext)
    }
    // MARK: -
}
extension UIViewControllerContextTransitioning {
    var fromVC: UIViewController {
        return viewController(forKey: .from)!
    }
    var toVC: UIViewController {
        return viewController(forKey: .to)!
    }
    var fromView: UIView {
        return view(forKey: .from)!
    }
    var toView: UIView {
        return view(forKey: .to)!
    }
    var fromWidth: CGFloat {
        return initialFrame(for: fromVC).size.width
    }
    var toWidth: CGFloat {
        return finalFrame(for: toVC).size.width
    }
}
