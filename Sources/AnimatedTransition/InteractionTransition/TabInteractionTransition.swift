//
//  TabInteractionTransition.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TabInteractionTransition: InteractionTransition {
    weak var tabbarVC: UITabBarController?
    public init(_ tabbarVC: UITabBarController) {
        super.init()
        self.tabbarVC = tabbarVC
    }

    var leftToRight: Bool = false
    override func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        guard let tabbarVC = self.tabbarVC else {return}
        let velocity = gesture.velocity(in: view)
        self.leftToRight = velocity.x > 0
        if self.leftToRight {
            if tabbarVC.selectedIndex > 0 {
                super.handleGestureBegin(gesture, view)
                tabbarVC.selectedIndex -= 1
            }
        } else {
            if tabbarVC.selectedIndex < tabbarVC.viewControllers!.count - 1 {
                super.handleGestureBegin(gesture, view)
                tabbarVC.selectedIndex += 1
            }
        }
    }
    override func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) -> CGFloat {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        let result: CGFloat

        let translation = gesture.translation(in: view)
        let screenWidth = UIScreen.main.bounds.size.width
        if self.leftToRight {
            result = translation.x / screenWidth
        } else {
            result = -translation.x / screenWidth
        }
        let velocity = gesture.velocity(in: view)
        if velocity.x < 0 && !self.leftToRight {
            self.shouldCompleteTransition = true
        } else if velocity.x > 0 && self.leftToRight {
            self.shouldCompleteTransition = true
        } else {
            self.shouldCompleteTransition = false
        }
        return result
    }

}
