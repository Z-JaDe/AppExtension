//
//  InteractionController.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

public enum InteractionOperation {
    case Pop
    case Dismiss
    case Tab
}
private var gestureKey: UInt8 = 0
open class InteractionController: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController?
    var shouldCompleteTransition: Bool = false
    var percentValue: CGFloat = 0

    public fileprivate(set) var interactionInProgress: Bool = false
    public var sensitivityValue: CGFloat = 1.35
    public var interactiveUpdate: ((CGFloat) -> Void)?
    public var interactiveComplete: ((Bool) -> Void)?

    public weak var fromVC: UIViewController?
    public weak var toVC: UIViewController?

    open func wire(to viewCon: UIViewController) {
        self.viewController = viewCon
        prepareGestureRecognizer(in: viewCon)
    }
    func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
        self.interactionInProgress = true
    }
    func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) {
        fatalError()
    }
    // MARK: - 
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        fromVC = transitionContext.viewController(forKey: .from)!
        toVC = transitionContext.viewController(forKey: .to)!
        super.startInteractiveTransition(transitionContext)
    }
    open override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        self.interactiveUpdate?(percentComplete)
    }
    open override func cancel() {
        super.cancel()
        self.interactiveComplete?(true)
    }
    open override func finish() {
        super.finish()
        self.interactiveComplete?(false)
    }
}
extension InteractionController {
    fileprivate func prepareGestureRecognizer(in viewCon: UIViewController) {
        let panGesture = viewCon.view.panGesture
        panGesture.removeTarget(self, action: #selector(handleGesture(_: )))
        panGesture.addTarget(self, action: #selector(handleGesture(_: )))
    }
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let view: UIView = gesture.view!.superview!
        switch gesture.state {
        case .began:
            handleGestureBegin(gesture, view)
        case .changed:
            guard self.interactionInProgress else {
                return
            }
            self.updatePercent(gesture, view)
            self.formatPercent()

            self.update(percentValue)
        case .ended, .cancelled:
            guard self.interactionInProgress else {
                return
            }
            self.interactionInProgress = false
            if !self.shouldCompleteTransition || gesture.state == .cancelled {
                self.cancel()
            } else {
                self.finish()
            }
        default:
            break
        }
    }
    func formatPercent() {
        percentValue *= sensitivityValue
        percentValue = min(percentValue, 0.99)
        percentValue = max(percentValue, 0.01)
    }
}
