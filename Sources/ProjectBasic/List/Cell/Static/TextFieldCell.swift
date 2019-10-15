//
//  TextFieldCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/21.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
extension Font.List {
    public static var textField: UIFont = Font.thinh2
}
extension Color.List {
    public static var textField: UIColor = Color.black
}
open class TextFieldCell: TitleCell, CheckAndCatchParamsProtocol {
    public convenience init(img: ImageData? = nil, title: String = "", placeholder: String = "") {
        self.init(img: img, title: title)
        self.textField.placeholder = placeholder
    }
    public var autoBeginInputWhenSelectedItem: Bool = true
    // MARK: -
    public lazy var textField: TextField = TextField(color: Color.List.textField, font: Font.List.textField)
    public var textFieldText: String {
        self.textField.text ?? ""
    }
    open override func configInit() {
        super.configInit()
        self.separatorLineHeight = 1
        self.highlightedAnimation = .none
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    open override func addChildView() {
        super.addChildView()
        stackView.addArrangedSubview(self.textField)
    }
    open override func configLayout() {
        super.configLayout()
        self.titleLabel.contentHuggingPriority(.required)
        self.textField.contentHuggingHorizontalPriority = .defaultLow
    }

    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        self.textField.isEnabled = isEnabled
    }
    open override func didSelectItem() {
        super.didSelectItem()
        if self.textField.isFirstResponder == false && self.autoBeginInputWhenSelectedItem && self.accessoryView == nil {
            self.textField.becomeFirstResponder()
        }
    }
    // MARK: - CheckAndCatchParamsProtocol
    open func checkParams() -> Bool {
        guard self.textField.text.isNotNilNotEmpty else {
            HUD.showError(self.catchParamsErrorPrompt ?? self.textField.placeholder ?? "Prompt: 请输入")
            return false
        }
        return true
    }

    open func catchParams() -> [String: Any] {
        [key: self.textFieldText]
    }
}
extension TextField {
    public func checkIsVerificationCode() -> Bool {
        guard let text = self.text, text.isNotEmpty else {
            HUD.showError("请输入验证码")
            return false
        }
        guard text.isCode else {
            HUD.showError("请输入正确的验证码")
            return false
        }
        return true
    }
    public func checkIsPhone() -> Bool {
        guard let text = self.text, text.isNotEmpty else {
            HUD.showError("请输入手机号码")
            return false
        }
        guard text.isMobilePhone else {
            HUD.showError("请输入正确的手机号码")
            return false
        }
        return true
    }
    public func checkIsRealName() -> Bool {
        guard let text = self.text, text.isNotEmpty else {
            HUD.showError("请输入姓名")
            return false
        }
        guard text.isTrueName else {
            HUD.showError("请输入真实姓名")
            return false
        }
        return true
    }
    public func checkIsIDCard() -> Bool {
        guard let text = self.text, text.isNotEmpty else {
            HUD.showError("请输入身份证号")
            return false
        }
        guard text.isIdentificationNo else {
            HUD.showError("身份证号有误")
            return false
        }
        return true
    }
    public func checkIsBankCode() -> Bool {
        guard let text = self.text, text.isNotEmpty else {
            HUD.showError("请输入银行卡号")
            return false
        }
        guard text.isValidBankCard else {
            HUD.showError("银行卡输入有误")
            return false
        }
        return true
    }
}
