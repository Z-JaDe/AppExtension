//
//  NavInteractionTransition.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

//import UIKit
//
//open class NavInteractionTransition: InteractionTransition {
//    open var popOnRightToLeft: Bool = false
//
//    override func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
//        guard let gesture = gesture as? UIPanGestureRecognizer else {
//            fatalError()
//        }
//        let velocity = gesture.velocity(in: view)
//        let rightToLeft = velocity.x < 0
//        guard self.popOnRightToLeft == rightToLeft else {
//            return
//        }
//        super.handleGestureBegin(gesture, view)
//        self.viewController?.navigationController?.popViewController(animated: true)
//    }
//    override func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) {
//        guard let gesture = gesture as? UIPanGestureRecognizer else {
//            fatalError()
//        }
//        let translation = gesture.translation(in: view)
//        percentValue = translation.x / 200
//        let velocity = gesture.velocity(in: view)
//        if velocity.x < 0 && self.popOnRightToLeft {
//            self.shouldCompleteTransition = true
//        } else if velocity.x > 0 && !self.popOnRightToLeft {
//            self.shouldCompleteTransition = true
//        } else {
//            self.shouldCompleteTransition = false
//        }
//    }
//}
