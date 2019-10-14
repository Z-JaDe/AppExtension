//
//  AttributedStringMakerProtocol.swift
//  AppExtension
//
//  Created by Apple on 2019/10/14.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol AttributedStringMakerProtocol {
    func createMaker() -> AttributedStringMaker
}
extension AttributedStringMaker: AttributedStringMakerProtocol {
    public func createMaker() -> AttributedStringMaker {
        return self
    }
}
extension String: AttributedStringMakerProtocol {
    public func createMaker() -> AttributedStringMaker {
        AttributedStringMaker(self)
    }
}
extension NSAttributedString: AttributedStringMakerProtocol {
    public func createMaker() -> AttributedStringMaker {
        AttributedStringMaker(self)
    }
}
// MARK: -
public extension AttributedStringMakerProtocol {
    func setAttribute(_ key: NSAttributedString.Key, value: Any?, range: NSRange?) -> AttributedStringMaker {
        createMaker()._setAttribute(key, value: value, range: range)
    }
    func paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) -> AttributedStringMaker {
        createMaker()._paragraphStyle(style, range: range)
    }
}
public extension AttributedStringMakerProtocol {
    func color(_ color: UIColor?, range: NSRange? = nil) -> AttributedStringMaker {
        createMaker()._setAttribute(.foregroundColor, value: color, range: range)
    }
    func font(_ font: UIFont?, range: NSRange? = nil) -> AttributedStringMaker {
        createMaker()._setAttribute(.font, value: font, range: range)
    }
    func underLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> AttributedStringMaker {
        return createMaker().then { (maker) in
            if let color = color {
                let underLineStyle: NSUnderlineStyle = NSUnderlineStyle.single
                maker._setAttribute(.underlineStyle, value: NSNumber(value: underLineStyle.rawValue), range: range)
                maker._setAttribute(.underlineColor, value: color, range: range)
            } else {
                maker._setAttribute(.underlineStyle, value: nil, range: range)
                maker._setAttribute(.underlineColor, value: nil, range: range)
            }
        }
    }
    func deleteLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> AttributedStringMaker {
        return createMaker().then { (maker) in
            if let color = color {
                let underLineStyle: NSUnderlineStyle = NSUnderlineStyle.single
                maker._setAttribute(.strikethroughStyle, value: NSNumber(value: underLineStyle.rawValue), range: range)
                maker._setAttribute(.strikethroughColor, value: color, range: range)
            } else {
                maker._setAttribute(.underlineStyle, value: nil, range: range)
                maker._setAttribute(.underlineColor, value: nil, range: range)
            }
        }
    }
    func kern(_ kern: Double?, range: NSRange? = nil) -> AttributedStringMaker {
        let value: NSNumber? = {
            if let kern = kern {return NSNumber(value: kern)}
            return nil
        }()
        return createMaker()._setAttribute(.kern, value: value, range: range)
    }
    // MARK: paragraphStyle
    func alignment(_ alignment: NSTextAlignment, range: NSRange? = nil) -> AttributedStringMaker {
        createMaker()._setParagraphStyleAttr(\.alignment, alignment, range)
    }
    func lineSpacing(_ spacing: CGFloat, range: NSRange? = nil) -> AttributedStringMaker {
        createMaker()._setParagraphStyleAttr(\.lineSpacing, spacing, range)
    }
}
