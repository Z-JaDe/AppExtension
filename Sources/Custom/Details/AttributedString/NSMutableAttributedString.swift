//
//  NSMutableAttributedString.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension NSAttributedString {
    public func color(_ color: UIColor?, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).color(color, range: range).attr()
    }
    public func font(_ font: UIFont?, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).font(font, range: range).attr()
    }
    public func underLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).underLine(color, range: range).attr()
    }
    public func deleteLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).deleteLine(color, range: range).attr()
    }
    public func kern(_ kern: Double?, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).kern(kern, range: range).attr()
    }
    // MARK: - paragraphStyle
    @discardableResult
    public func paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).paragraphStyle(style, range: range).attr()
    }
    public func alignment(_ alignment: NSTextAlignment, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).alignment(alignment, range: range).attr()
    }
    public func lineSpacing(_ spacing: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString {
        return AttributedStringMaker(self).lineSpacing(spacing, range: range).attr()
    }
}
