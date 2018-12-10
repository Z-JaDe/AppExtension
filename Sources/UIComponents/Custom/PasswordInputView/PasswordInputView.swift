//
//  PasswordInputView.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/8/2.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

public class PasswordInputView: CustomView {
    public var passwordMaxLength: Int = 6 {
        didSet {
            self.resetItemViews()
            self.clearPassword()
        }
    }
    public var passwordStr: String {
        return self.textField.text ?? ""
    }
    public var isSecureTextEntry: Bool = true {
        didSet {updateShowItems()}
    }
    public var itemSpace: CGFloat = 18 {
        didSet {setNeedsLayout()}
    }
    public var passwordCallback: ((String) -> Void)?
    // MARK: -
    private let textField = TextField()
    private lazy var itemViews = [PasswordInputItemView]()
    public override func configInit() {
        super.configInit()
        self.textField.tintColor = Color.clear
        self.textField.textColor = Color.clear
        self.textField.keyboardType = .numberPad
        self.textField.clearButtonMode = .never
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        self.addSubview(self.textField)
        resetItemViews()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.textField.frame = self.bounds
        let startLocation = self.width - self.intrinsicContentSize.width
        _ = self.itemViews.reduce(startLocation / 2, { (latest, itemView) -> CGFloat in
            itemView.sizeToFit()
            itemView.left = latest
            return itemView.right + self.itemSpace
        })
    }
    public override var intrinsicContentSize: CGSize {
        var height: CGFloat = 0
        let width: CGFloat = self.itemViews.reduce(0) { (latest, itemView) -> CGFloat in
            itemView.sizeToFit()
            if height < itemView.height {
                height = itemView.height
            }
            return latest + itemView.width + self.itemSpace
        } - self.itemSpace
        return CGSize(width: width, height: height)
    }

}
extension PasswordInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        }
        let oldText = textField.text ?? ""
        guard let range = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: range, with: string)
        return newText.count <= self.passwordMaxLength
    }
}
extension PasswordInputView {
    @objc open func textDidChange() {
        self.updateShowItems()
        if self.passwordMaxLength <= self.passwordStr.count {
            passwordCallback?(String(self.passwordStr.prefix(self.passwordMaxLength)))
        }
    }
    public func beginInput() {
        self.textField.becomeFirstResponder()
    }
    public func endInput() {
        self.textField.resignFirstResponder()
    }
    public func changePassword(_ text: String) {
        self.textField.text = text
        self.textField.sendActions(for: .editingChanged)
    }
    public func clearPassword() {
        self.textField.text = ""
        self.textField.sendActions(for: .editingChanged)
    }
}
extension PasswordInputView {
    private func resetItemViews() {
        self.itemViews.countIsEqual(count: self.passwordMaxLength, append: {_ in PasswordInputItemView()}, remove: {$0.removeFromSuperview()})
        self.itemViews.forEach { (itemView) in
            if itemView.superview != self {
                self.addSubview(itemView)
            }
        }
        self.setNeedsLayout()
    }
    private func updateShowItems() {
        self.itemViews.lazy.enumerated().forEach { (index, itemView) in
            if index < passwordStr.count {
                itemView.showPoint(self.isSecureTextEntry ? "*" : String(passwordStr[index]))
            } else {
                itemView.hidePoint()
            }
        }
    }
}
private class PasswordInputItemView: CustomView {
    private let pointView = Label(color: Color.black, font: Font.boldh1)
    private var isShow: Bool = true
    override func configInit() {
        super.configInit()
        self.isUserInteractionEnabled = false
        self.cornerRadius = 3
        self.addBorder(width: 1.5, color: Color.lightGray)
        self.pointView.textColor = Color.black
        self.pointView.textAlignment = .center
        self.hidePoint(animated: false)
    }
    override func addChildView() {
        super.addChildView()
        self.addSubview(self.pointView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.pointView.sizeToFit()
        self.pointView.center = CGPoint(x: self.width / 2, y: self.height / 2)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.intrinsicContentSize
    }
    // MARK: -
    func showPoint(_ text: String) {
        if text != self.pointView.text {
            self.pointView.text = text
        }
        guard isShow == false else {
            return
        }
        self.isShow = true
        Animater().animations {
            self.pointView.alpha = 1
            self.pointView.transform = CGAffineTransform.identity
        }.animate()
    }
    func hidePoint(animated: Bool = true) {
        guard isShow == true else {
            return
        }
        self.isShow = false
        Animater().duration(animated ? 0.25 : 0).animations {
            self.pointView.alpha = 0
            self.pointView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }.animate()
    }
}
