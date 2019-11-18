//
//  SwitchCell.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/8/16.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

open class SwitchCell: TitleCell {
    // MARK: -
    public lazy var switchView: SwitchView = SwitchView()

    open override func configInit() {
        super.configInit()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func addChildView() {
        super.addChildView()
        stackView.addArrangedSubview(self.switchView)
    }
    open override func configLayout() {
        super.configLayout()
        self.titleLabel.contentHuggingPriority(UILayoutPriority(rawValue: 999))
        self.switchView.contentHuggingPriority(.required)
    }
    // MARK: -
    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        self.switchView.isEnabled = isEnabled
    }
    open override func didSelectItem() {
        super.didSelectItem()
        if self.switchView.isFirstResponder == false {
            self.switchView.becomeFirstResponder()
        }
    }
    // MARK: - CheckAndCatchParamsProtocol
    open func checkParams() -> Bool {
        true
    }

    open func catchParams() -> [String: Any] {
        [key: self.switchView.isOn]
    }
}
