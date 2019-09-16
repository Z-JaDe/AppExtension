//
//  TextViewCell.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/29.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
extension Font.List {
    public static var textView: UIFont = Font.thinh2
}
extension Color.List {
    public static var textView: UIColor = Color.black
}
open class TextViewCell: TitleCell, CheckAndCatchParamsProtocol {
    public convenience init(img: ImageData? = nil, title: String = "", placeholder: String = "") {
        self.init(img: img, title: title)
        self.textView.placeholder = placeholder
    }
    // MARK: -
    public lazy var textView: TextView = TextView(color: Color.List.textView, font: Font.List.textView)
    public var textViewText: String {
        self.textView.text ?? ""
    }
    open override func configInit() {
        super.configInit()
        self.textView.clipsToBounds = false
        self.textView.contentInset = .zero
        self.textView.textContainer.lineFragmentPadding = 0
        self.separatorLineHeight = 1
        self.highlightedAnimation = .none
    }
    /// ZJaDe: autoUpdateHeightWithContentSize
    open func autoUpdateHeightWithContentSize() {
        self.textView.contentSizeChanged = { [weak self] (contentSize) in
            guard let self = self else { return }
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
        [key: self.textView.text ?? ""]
    }

}
