//
//  Button.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class Button: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
    }
    // MARK: - Round
    private var isRound: Bool = false
    open override func roundView() {
        self.isRound = true
        super.roundView()
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.isRound {
            self.roundView()
        }
    }
    // MARK: -
    public convenience init(image: UIImage?, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setImage(image, for: .normal)
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    public convenience init(text: String, color: UIColor, font: UIFont, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
}
