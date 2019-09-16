//
//  NSMutableAttributedString.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension NSAttributedString {
    public var maker: AttributedStringMaker {
        AttributedStringMaker(self)
    }
    public func color(_ color: UIColor?, range: NSRange? = nil) -> NSAttributedString {
        maker.color(color, range: range).attr()
    }
    public func font(_ font: UIFont?, range: NSRange? = nil) -> NSAttributedString {
        maker.font(font, range: range).attr()
    }
    public func underLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> NSAttributedString {
        maker.underLine(color, range: range).attr()
    }
    public func deleteLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> NSAttributedString {
        maker.deleteLine(color, range: range).attr()
    }
    public func kern(_ kern: Double?, range: NSRange? = nil) -> NSAttributedString {
        maker.kern(kern, range: range).attr()
    }
    // MARK: - paragraphStyle
    @discardableResult
    public func paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) -> NSAttributedString {
        maker.paragraphStyle(style, range: range).attr()
    }
    public func alignment(_ alignment: NSTextAlignment, range: NSRange? = nil) -> NSAttributedString {
        maker.alignment(alignment, range: range).attr()
    }
    public func lineSpacing(_ spacing: CGFloat, range: NSRange? = nil) -> NSAttributedString {
        maker.lineSpacing(spacing, range: range).attr()
    }
}
