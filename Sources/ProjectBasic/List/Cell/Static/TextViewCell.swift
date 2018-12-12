//
//  TextViewCell.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/29.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

open class TextViewCell: TitleCell, CheckAndCatchParamsProtocol {
    public convenience init(img: ImageData? = nil, title: String = "", placeholder: String = "") {
        self.init(img: img, title: title)
        self.textView.placeholder = placeholder
    }
    // MARK: -
    public lazy var textView: TextView = TextView(color: Color.black, font: Font.thinh2)
    public var textViewText: String {
        return self.textView.text ?? ""
    }
    open override func configInit() {
        super.configInit()
        self.textView.clipsToBounds = false
        self.textView.contentInset = .zero
        self.textView.textContainer.lineFragmentPadding = 0
        self.highlightedAnimation = .none
    }
    /// ZJaDe: autoUpdateHeightWithContentSize
    open func autoUpdateHeightWithContentSize() {
        self.textView.contentSizeChanged = { (contentSize) in
            let height = max(contentSize.height, 34)
            self.defaultHeight = height
            /// ZJaDe: 及时更新下textView的高度 防止contentOffset出现未知变动
            Animater().animations {
                self.updateLayouts(self.textView.snp.prepareConstraints({ (maker) in
                    maker.height.equalTo(height)
                }))
                self.textView.setNeedsLayout()
                self.textView.layoutIfNeeded()
            }.animate()
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func addChildView() {
        super.addChildView()
        stackView.addArrangedSubview(self.textView)
    }
    open override func configLayout() {
        super.configLayout()
        self.titleLabel.contentHuggingPriority(.required)
        self.textView.contentHuggingHorizontalPriority = .defaultLow
        self.textView.snp.makeConstraints { (maker) in
            maker.bottom.right.equalToSuperview()
        }
    }

    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        self.textView.isEditable = isEnabled
    }
    open override func didSelectItem() {
        super.didSelectItem()
        if self.textView.isFirstResponder == false {
            self.textView.becomeFirstResponder()
        }
    }
    // MARK: - CheckAndCatchParamsProtocol
    open func checkParams() -> Bool {
        guard let text = self.textView.text, text.isNotEmpty else {
            HUD.showError(self.catchParamsErrorPrompt ?? self.textView.placeholder.nilIfEmpty ?? "Prompt: 请输入")
            return false
        }
        return true
    }

    open func catchParams() -> [String: Any] {
        return [key: self.textView.text ?? ""]
    }

}