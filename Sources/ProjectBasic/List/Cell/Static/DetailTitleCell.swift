//
//  DetailTitleCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/21.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class DetailTitleCell: TitleCell, CheckAndCatchParamsProtocol {
    public convenience init(img: ImageData? = nil, title: String, detailText: String) {
        self.init(img: img, title: title)
        self.detailTitleLabel.text = detailText
    }
    // MARK: -
    public private(set) lazy var detailTitleLabel: Label = Label(color: Color.black, font: Font.thinh4)
    open override func configInit() {
        super.configInit()
        configSingleLineRight()
    }
    // MARK: - config
    open func configSingleLineRight() {
        self.detailTitleLabel.textAlignment = .right
        self.detailTitleLabel.numberOfLines = 1
        self.defaultHeight = 34
    }
    open func configSingleLineLeft() {
        self.detailTitleLabel.textAlignment = .left
        self.detailTitleLabel.numberOfLines = 1
        self.defaultHeight = 34
    }
    open func configMultipleLines() {
        self.detailTitleLabel.textAlignment = .left
        self.detailTitleLabel.numberOfLines = 0
        self.defaultHeight = 0
    }
    // MARK: -
    open override func addChildView() {
        super.addChildView()
        self.stackView.addArrangedSubview(self.detailTitleLabel)
    }
    open override func configLayout() {
        super.configLayout()
        self.titleLabel.contentHuggingPriority(.required)
        self.detailTitleLabel.contentHuggingHorizontalPriority = .defaultLow
    }
    // MARK: - CheckAndCatchParamsProtocol
    open func checkParams() -> Bool {
        guard self.detailTitleLabel.text.isNotNilNotEmpty else {
            HUD.showError(self.catchParamsErrorPrompt ?? "Prompt: 请选择")
            return false
        }
        return true
    }

    open func catchParams() -> [String: Any] {
        return [key: self.detailTitleLabel.text ?? ""]
    }
}
