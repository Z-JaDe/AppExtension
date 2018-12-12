//
//  TabBarItem.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/19.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

open class TabBarItem: UITabBarItem {
    open override var title: String? {
        get {return nil}
        set {}
    }
    open override var image: UIImage? {
        get {return nil}
        set {}
    }

    public var itemModel: TabBarItemModel {
        didSet {
            self.itemView.model = self.itemModel
        }
    }
    public init(_ itemModel: TabBarItemModel) {
        self.itemModel = itemModel
        super.init()

    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    lazy var itemView: TabBarItemView = TabBarItemView(model: self.itemModel)

    func deselectAnimation() {
        self.itemModel.isSelected = false
        self.itemModel.animation?.deselectAnimation(itemView.imageView, textLabel: itemView.titleLabel)
    }
    func selectAnimation() {
        self.itemModel.isSelected = true
        self.itemModel.animation?.playAnimation(itemView.imageView, textLabel: itemView.titleLabel)
    }
}