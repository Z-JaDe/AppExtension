//
//  TitleCell.swift
//  SNKit_TJS
//
//  Created by 苏义坤 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

extension Font.List {
    public static var title: UIFont = Font.thinh3
}
extension Color.List {
    public static var title: UIColor = Color.black
}
open class TitleCell: StaticTableItemCell {
    public convenience init(img: ImageData? = nil, title: String) {
        self.init()
        self.imgData = img
        self.title = title
        configImageData()
        configTitle()
    }
    public var imgData: ImageData? {
        didSet {configImageData()}
    }
    func configImageData() {
        self.imageView.setImage(self.imgData)
        self.imageView.isHidden = self.imgData.isNilOrEmpty
    }
    public var title: String = "" {
        didSet {configTitle()}
    }
    public var attrTitle: NSAttributedString? {
        didSet {configTitle()}
    }
    func configTitle() {
        if let attrTitle = self.attrTitle {
            self.titleLabel.attributedText = attrTitle
        } else {
            self.titleLabel.text = self.title
        }
        self.titleLabel.isHidden = self.title.isEmpty && self.attrTitle == nil
    }

    // MARK: -
    /// ZJaDe: 不要直接设置imageView的image 使用self.imgData
    public private(set) lazy var imageView: ImageView = {
        let imageView = ImageView()
        imageView.isHidden = true
        imageView.snp.makeConstraints { (make) in
            make.size.lessThanOrEqualTo(CGSize(width: 44, height: 44))
        }
        return imageView
    }()
    /// ZJaDe: 不要直接设置titleLabel的text 使用self.title 或 self.attrTitle
    public private(set) lazy var titleLabel: Label = Label(color: Color.List.title, font: Font.List.title)
    public private(set) lazy var stackView: UIStackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: Space.itemSpace)

    open override func configInit() {
        super.configInit()
        self.defaultHeight = 34
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.stackView)
        stackView.addArrangedSubview(self.imageView)
        stackView.addArrangedSubview(self.titleLabel)
    }
    open override func configLayout() {
        self.imageView.contentHuggingPriority(.required)
        self.stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
}
