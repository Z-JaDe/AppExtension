////
////  TabInteractionController.swift
////  PaiBaoTang
////
////  Created by 茶古电子商务 on 2017/7/27.
////  Copyright © 2017年 Z_JaDe. All rights reserved.
////
//
//import UIKit
//
//open class TabInteractionController: InteractionController {
//    var leftToRight: Bool = false
//    override func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
//        guard let gesture = gesture as? UIPanGestureRecognizer else {
//            fatalError()
//        }
//        let velocity = gesture.velocity(in: view)
//        percentValue = 0
//        self.leftToRight = velocity.x > 0
//        let tabbarVC = viewController!.tabBarController!
//        if self.leftToRight {
//            if tabbarVC.selectedIndex > 0 {
//                super.handleGestureBegin(gesture, view)
//                tabbarVC.selectedIndex -= 1
//            }
//        } else {
//            if tabbarVC.selectedIndex < tabbarVC.viewControllers!.count - 1 {
//                super.handleGestureBegin(gesture, view)
//                tabbarVC.selectedIndex += 1
//            }
//        }
//    }
//    override func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) {
//        guard let gesture = gesture as? UIPanGestureRecognizer else {
//            fatalError()
//        }
//        let translation = gesture.translation(in: view)
//        let screenWidth = UIScreen.main.bounds.size.width
//        if self.leftToRight {
//            percentValue = translation.x / screenWidth
//        } else {
//            percentValue = -translation.x / screenWidth
//        }
//
//        let velocity = gesture.velocity(in: view)
//        if velocity.x < 0 && !self.leftToRight {
//            self.shouldCompleteTransition = true
//        } else if velocity.x > 0 && self.leftToRight {
//            self.shouldCompleteTransition = true
//        } else {
//            self.shouldCompleteTransition = false
//        }
//    }
//
//}
