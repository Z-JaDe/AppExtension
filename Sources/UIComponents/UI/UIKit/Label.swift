//
//  Label.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class Label: UILabel {
    open override var font: UIFont! {
        didSet { updateFirstBaseline() }
    }

    public convenience init(text: String = "", color: UIColor = Color.black, font: UIFont = Font.h3) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = font
    }

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
            self.font = Font.h3
        }
        self.addSubview(self.firstBaselineView)
    }
    // ZJaDe: 
    open var textInset: UIEdgeInsets = .zero
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        return rect + self.textInset
    }

    // MARK: -
    private let firstBaselineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.isHidden = true
        return view
    }()
    func updateFirstBaseline() {
        self.firstBaselineView.top = (self.font.lineHeight - self.font.pointSize) / 2
    }
    open override var forFirstBaselineLayout: UIView {
        updateFirstBaseline()
        return firstBaselineView
    }
}
