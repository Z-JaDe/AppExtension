//
//  TabBarItemView.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

class TabBarItemView: CustomView, ConfigModelProtocol {

    let titleLabel: Label = Label()
    let imageView: ImageView = ImageView()
    lazy var badgeView: BadgeView = BadgeView.badge()

    var model: TabBarItemModel {
        didSet {
            configData(with: self.model)
        }
    }
    init(model: TabBarItemModel) {
        self.model = model
        super.init(frame: CGRect.zero)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    override func configInit() {
        super.configInit()
        configData(with: self.model)
        self.isUserInteractionEnabled = false
        self.titleLabel.textAlignment = .center
    }
    override func addChildView() {
        super.addChildView()
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
    }

    func configData(with model: TabBarItemModel) {
        let color = model.isSelected ? model.selectedColor : model.color
        var attributedDict: [NSAttributedString.Key: Any] = [: ]
        if let textFont = model.textFont {
            attributedDict[.font] = textFont
        }
        attributedDict[.foregroundColor] = color
        self.titleLabel.attributedText = NSAttributedString(string: model.title, attributes: attributedDict)

        self.imageView.tintColor = color

        if model.isSelected {
            if let selectImage = model.selectedImage {
                self.imageView.image = selectImage
            } else if let selectedImage = model.animation?.selectedImage {
                self.imageView.image = selectedImage
            } else {
                self.imageView.image = model.image.templateImage
            }
        } else {
            self.imageView.image = model.image
        }
        configBadge(model.badgeValue)
        setNeedsLayout()
    }
    func configBadge( _ value: String?) {
        if let value = value {
            self.badgeView.addBadgeOnView(self)
            self.badgeView.text = value
        } else {
            badgeView.removeFromSuperview()
            self.badgeView.text = nil
        }
    }

    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        imageView.sizeToFit()

        let centerX = self.width / 2
        titleLabel.centerX = centerX
        imageView.centerX = centerX
        titleLabel.bottom = self.height - 5
        imageView.bottom = titleLabel.top - 2
    }
}
