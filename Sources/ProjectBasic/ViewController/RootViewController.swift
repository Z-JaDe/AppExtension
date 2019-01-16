//
//  RootViewController.swift
//  SNKit_TJS
//
//  Created by syk on 2018/5/9.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

public class RootViewController: ItemViewController {
    public var contentVC: UIViewController {
        didSet {
            self.removeAsChildViewController(oldValue)
            self.addAsChildViewController(self.contentVC)
            self.view.setNeedsLayout()
        }
    }

    public init(_ contentVC: UIViewController) {
        self.contentVC = contentVC
        super.init()
    }

    public var rootNavC: UINavigationController? {
        if let tabbarVC = self.contentVC as? UITabBarController {
            return tabbarVC.selectedViewController as? UINavigationController
        } else if let navC = self.contentVC as? UINavigationController {
            return navC
        }
        return nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    public override func addChildView() {
        super.addChildView()
        self.addAsChildViewController(self.contentVC)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.contentVC.view.frame = self.view.bounds
    }

}
