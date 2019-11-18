//
//  ButtonCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/21.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class ButtonCell: StaticTableItemCell {
    public let button: Button
    public init(_ button: Button) {
        self.button = button
        super.init(frame: CGRect.zero)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public convenience init(_ title: String) {
        self.init(ButtonCell.createDefaultButton())
        self.change(title)
    }

    private static func createDefaultButton() -> Button {
        let button = Button()
        button.cornerRadius = 5
        button.clipsToBounds = true
        button.setBackgroundColor(Color.tintColor, for: .normal)
        button.setTitleColor(Color.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }

    public func change(_ title: String) {
        self.button.setTitle(title, for: .normal)
    }
    open override func configInit() {
        super.configInit()
        self.cellBackgroundColor = Color.clear
        self.cellSelectedBackgroundColor = nil
        self.insets.left = 30
        self.insets.right = 30
        self.separatorLineHeight = 0
        self.button.rx.throttleTouchUpInside()
            .subscribeOnNext({ [weak self] () in
                self?.sendDidSelectItemEvent()
            })
            .disposed(by: self.disposeBag)
    }

    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.button)
    }
    open override func configLayout() {
        super.configLayout()
        self.button.edgesToSuper()
    }

    open override func didSelectItem() {
//        self.button.sendActions(for: .touchUpInside)
    }

    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        self.button.isEnabled = isEnabled
    }
}
