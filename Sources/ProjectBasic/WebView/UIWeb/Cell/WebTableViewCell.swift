//
//  WebTableViewCell.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/14.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class WebTableViewCell: StaticTableItemCell {

    public let webVC: WebViewController = WebViewController()

    open override func configInit() {
        super.configInit()
        self.cellBackgroundColor = Color.clear
        self.separatorLineHeight = 0
        self.separatorLineInsets = (0, 0)
        self.webVC.autoUpdateHeightWithContentSize()
    }
    open override func defaultInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.webVC.rootView)
    }

    open override func willAppear() {
        super.willAppear()
        guard let viewCon = self.viewController(UIViewController.self) else {
            return
        }
        viewCon.addChild(self.webVC)
    }
    open override func didDisappear() {
        super.willAppear()
        self.webVC.removeFromParent()
    }

    open override func configLayout() {
        super.configLayout()
        self.webVC.rootView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        self.webVC.rootView.contentVerticalPriority(.required)
    }
}
