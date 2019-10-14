//
//  TextField.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
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
        didSet {
            self.placeholderFont = self.placeholderFont.flatMap({$0})
            self.placeholderColor = self.placeholderColor.flatMap({$0})
        }
    }
    public var placeholderFont: UIFont? {
        didSet { self.attributedPlaceholder = self.attributedPlaceholder.flatMap({$0.font(placeholderFont).finalize()}) }
    }
    public var placeholderColor: UIColor? {
        didSet { self.attributedPlaceholder = self.attributedPlaceholder.flatMap({$0.color(placeholderColor).finalize()}) }
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
