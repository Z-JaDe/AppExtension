//
//  TextField.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class TextField: UITextField {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    open func configInit() {
        if self.textColor == nil {
            self.textColor = Color.black
        }
        if self.font == nil {
            self.font = Font.thinh3
        }
        self.placeholderColor = Color.placeholder
    }
    open override var placeholder: String? {
        didSet { updatePlaceholder() }
    }
    public var placeholderFont: UIFont? {
        didSet { updatePlaceholder() }
    }
    public var placeholderColor: UIColor? {
        didSet { updatePlaceholder() }
    }
    func updatePlaceholder() {
        if let attr = self.attributedPlaceholder {
            var maker = attr.asAttributedStringClass()
            if let color = self.placeholderColor {
                maker = maker.color(color)
            }
            if let font = self.placeholderFont {
                maker = maker.font(font)
            }
            self.attributedPlaceholder = maker.finalize()
        }
    }
    // MARK: -
    /// 输入框text位置
    open var textInset: UIEdgeInsets = .zero

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds) - textInset
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds) - textInset
    }

}
