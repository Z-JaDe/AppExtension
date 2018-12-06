//
//  StackViewControllerTest.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import Custom
class StackViewControllerTest: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 10, right: 50)
        
        let cycleProgress: CycleProgress = CycleProgress()
        cycleProgress.frame = CGRect(x: 50, y: 300, width: 100, height: 120)
        self.view.addSubview(cycleProgress)
        
        let view = UIImageView(image: UIImage(named: "ic_钱包_背景")!)
        view.frame = CGRect(x: 20, y: 250, width: 100, height: 100)
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = 10.0
        view.layer.shadowOffset = CGSize(width: 10, height: 10)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1.0
        self.view.addSubview(view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushSegment(_ sender: UIButton) {
        self.navigationController?.pushViewController(SegmentScrollViewViewControllerTest(), animated: true)
    }
    @IBAction func pushPageView(_ sender: UIButton) {
//        self.navigationController?.pushViewController(PageViewControllerTest(), animated: true)
    }
    @IBAction func pushCycleView(_ sender: UIButton) {
        self.navigationController?.pushViewController(CycleViewViewControllerTest(), animated: true)
    }
    @IBAction func pushFont(_ sender: UIButton) {
        self.navigationController?.pushViewController(FontViewControllerTest(), animated: true)
    }
    @IBAction func pushList(_ sender: UIButton) {
//        self.navigationController?.pushViewController(ListViewControllerTest(), animated: true)
    }

}
