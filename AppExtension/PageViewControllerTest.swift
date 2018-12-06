////
////  PageViewControllerTest.swift
////  AppExtension
////
////  Created by 郑军铎 on 2018/6/26.
////  Copyright © 2018年 ZJaDe. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Custom
//
//class PageViewControllerTest: UIViewController {
//    let pageViewCon = PageScrollViewController()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = Color.white
//        self.addAsChildViewController(pageViewCon)
//        
//        pageViewCon.viewConArr = [createViewCon(0), 
//                              createViewCon(1), 
//                              createViewCon(2)]
//    }
//    func createViewCon(_ index: Int) -> UIViewController {
//        let viewCon = ItemViewController()
//        viewCon.index = index
//        return viewCon
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        pageViewCon.view.frame = self.view.bounds
//    }
//    open override func willMove(toParent parent: UIViewController?) {
//        super.willMove(toParent: parent)
//    }
//    open override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = true
//        
//        self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.navigationBar.barTintColor = Color.blue.alpha(0.3)
//        self.navigationController?.navigationBar
//            .setBackgroundImage(UIImage.imageWithColor(Color.red.alpha(0.5)), for: .default)
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//    }
//}
