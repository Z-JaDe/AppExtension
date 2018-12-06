//
//  ImageView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ImageView: UIImageView {

    public convenience init() {
        self.init(image: nil)
    }
    public override init(image: UIImage?, highlightedImage: UIImage? = nil) {
        super.init(image: image, highlightedImage: highlightedImage)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
//        self.contentMode = .scaleAspectFill
    }

}
