//
//  NavInteractionController.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class NavInteractionController: InteractionController {
    open var popOnRightToLeft: Bool = false

//    override func getGesture(viewCon: UIViewController) -> UIGestureRecognizer? {
//        return viewCon.navigationController?.interactivePopGestureRecognizer
//    }
    override func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        let velocity = gesture.velocity(in: view)
        let rightToLeft = velocity.x < 0
        guard self.popOnRightToLeft == rightToLeft else {
            return
        }
        super.handleGestureBegin(gesture, view)
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    override func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        let translation = gesture.translation(in: view)
        percentValue = translation.x / 200
        print(percentValue)
        let velocity = gesture.velocity(in: view)
        if velocity.x < 0 && self.popOnRightToLeft {
            self.shouldCompleteTransition = true
        } else if velocity.x > 0 && !self.popOnRightToLeft {
            self.shouldCompleteTransition = true
        } else {
            self.shouldCompleteTransition = false
        }
    }
}
