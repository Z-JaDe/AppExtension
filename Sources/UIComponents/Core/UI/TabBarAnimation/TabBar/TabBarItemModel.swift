//
//  TabBarItemModel.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public struct TabBarItemModel {
    var index: Int = 0
    public var title: String
    public var image: UIImage
    public var selectedImage: UIImage?
    public var textFont: UIFont?
    public var color: UIColor?
    public var selectedColor: UIColor?
    public var animation: ItemAnimation?
    public var isSelected: Bool = false
    public var badgeValue: String?

    public init(_ title: String, _ image: UIImage, _ selectedImage: UIImage? = nil) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }
}
