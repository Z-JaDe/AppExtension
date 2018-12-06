//
//  SearchView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/17.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

open class SearchView: CustomView {
    public let textField: TextField = TextField()
    public let cancelButton: Button = Button(text: "取消", color: Color.white, font: Font.h3)
    public var text: String {
        return self.textField.text ?? ""
    }
    open override func configInit() {
        super.configInit()
        observerAction()
        self.clipsToBounds = true
        self.textField.backgroundColor = Color.white
        self.textField.placeholder = "搜索"
        self.textField.cornerRadius = 5
        self.textField.returnKeyType = .search
        self.cancelButton.contentPriority(.required)
    }
    // MARK: -
    private var observerArr: [NotificationToken] = []
    func observerAction() {
        do {
            let observer = NotificationCenter.default.observe(name: UITextField.textDidBeginEditingNotification, object: self.textField, queue: nil) {[weak self] (_) in
                self?.configCancelButton(isShow: true)
            }
            observerArr.append(observer)
        }
        do {
            let observer = NotificationCenter.default.observe(name: UITextField.textDidEndEditingNotification, object: self.textField, queue: nil) {[weak self] (_) in
                self?.configCancelButton(isShow: false)
            }
            observerArr.append(observer)
        }

        self.cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
    }
    deinit {
        self.cancelButton.removeTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
    }
    @objc func cancelButtonTap() {
        self.textField.endEditing(true)
    }
    // MARK: -
    open func configCancelButton(isShow: Bool, animated: Bool = true) {
        var array = self.cancelButton.snp.prepareConstraints { (maker) in
            if isShow {
                maker.right.equalToSuperview()
            }
        }
        array += self.textField.snp.prepareConstraints({ (maker) in
            if isShow == false {
                maker.right.equalToSuperview()
            }
        })
        Animater().duration(animated ? 0.5 : 0).animations {
            self.updateLayouts(tag: "cancel", array)
            self.cancelButton.alpha = isShow ? 1 : 0
            self.setNeedsLayout()
            self.layoutIfNeeded()
            }.animate()
    }

    // MARK: -
    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.textField)
        self.addSubview(self.cancelButton)
    }
    open override func configLayout() {
        self.textField.snp.makeConstraints { (maker) in
            maker.left.centerY.top.equalToSuperview()
        }
        self.cancelButton.snp.makeConstraints { (maker) in
            maker.centerY.top.equalToSuperview()
            maker.leftSpace(self.textField).offset(5)
        }
        configCancelButton(isShow: false, animated: false)
    }
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: jd.screenWidth, height: 30)
    }
}
