//
//  Fonts.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 16/9/14.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public protocol FontConfigerProtocol {
    func resetFonts(_ configer: FontConfiger)
}
public class FontConfiger {
    public static let shared: FontConfiger = FontConfiger()
    private init() {}
    public func systemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize)
    }
    public func boldSystemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: fontSize)
    }
    public func fontOfSize(name: String, size: CGFloat) -> UIFont? {
        return UIFont(name: name, size: size)
    }
}
// MARK: -
extension Font {
    public static func systemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return FontConfiger.shared.systemFontOfSize(fontSize)
    }
    public static func boldSystemFontOfSize(_ fontSize: CGFloat) -> UIFont {
        return FontConfiger.shared.boldSystemFontOfSize(fontSize)
    }
    public static func reset(_ configer: FontConfigerProtocol? = nil) {
        if let configer = configer ?? (FontConfiger.shared as? FontConfigerProtocol) {
            configer.resetFonts(FontConfiger.shared)
        }
    }
}
// MARK: -
public struct Font {

    ///大标题
    public static var thinh1 = thinFontSize(24)
    ///主标题
    public static var thinh2 = thinFontSize(18)
    ///正文
    public static var thinh3 = thinFontSize(16)
    ///副文
    public static var thinh4 = thinFontSize(13)
    ///最小
    public static var thinh5 = thinFontSize(11)

    ///大标题
    public static var h1 = fontSize(24)
    ///主标题
    public static var h2 = fontSize(18)
    ///正文
    public static var h3 = fontSize(16)
    ///副文
    public static var h4 = fontSize(13)
    ///最小
    public static var h5 = fontSize(11)

    ///大标题
    public static var boldh1 = boldFontSize(24)
    ///主标题
    public static var boldh2 = boldFontSize(18)
    ///正文
    public static var boldh3 = boldFontSize(16)
    ///副文
    public static var boldh4 = boldFontSize(13)
    ///最小
    public static var boldh5 = boldFontSize(11)

    public static var thinFontSize: (CGFloat) -> UIFont = { (size) in
        return systemFontOfSize(size)
    }
    public static var fontSize: (CGFloat) -> UIFont = { (size) in
        return systemFontOfSize(size)
    }
    public static var boldFontSize: (CGFloat) -> UIFont = { (size) in
        return boldSystemFontOfSize(size)
    }
    // MARK: - 
    public struct List {}
}
