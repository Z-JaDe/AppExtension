//
//  Color.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 16/9/14.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public protocol ColorConfigerProtocol {
    func resetColors(_ configer: ColorConfiger)
}
public class ColorConfiger {
    fileprivate static let shared: ColorConfiger = ColorConfiger()
    private init() {}
    public func colorFromRGB(_ hexString: String) -> UIColor? {
        var red: CGFloat
        var blue: CGFloat
        var green: CGFloat
        var alpha: CGFloat
        let colorString = hexString.replacingOccurrences(of: "#", with: "")
        switch colorString.count {
        case 3: //#RGB
            alpha = 1.0
            red   = colorComponentFrom(colorString, 0, 1)
            green = colorComponentFrom(colorString, 1, 1)
            blue  = colorComponentFrom(colorString, 2, 1)
        case 4: //#ARGB
            alpha = colorComponentFrom(colorString, 0, 1)
            red   = colorComponentFrom(colorString, 1, 1)
            green = colorComponentFrom(colorString, 2, 1)
            blue  = colorComponentFrom(colorString, 3, 1)
        case 6: //#RRGGBB
            alpha = 1.0
            red   = colorComponentFrom(colorString, 0, 2)
            green = colorComponentFrom(colorString, 2, 2)
            blue  = colorComponentFrom(colorString, 4, 2)
        case 8: //#AARRGGBB
            alpha = colorComponentFrom(colorString, 0, 2)
            red   = colorComponentFrom(colorString, 2, 2)
            green = colorComponentFrom(colorString, 4, 2)
            blue  = colorComponentFrom(colorString, 6, 2)
        default:
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    public func colorComponentFrom(_ string: String, _ start: Int, _ length: Int) -> CGFloat {
        let subString = string[string.index(string.startIndex, offsetBy: start) ..< string.index(string.startIndex, offsetBy: start+length)]
        let fullHex = length == 2 ? subString : subString+subString
        var hexComponent: UInt32 = 0
        if let screen = Scanner.localizedScanner(with: String(fullHex)) as? Scanner {
            screen.scanHexInt32(&hexComponent)
        }
        return CGFloat(hexComponent) / 255.0
    }
}
// MARK: -
extension Color {
    public static func colorFromRGB(_ hexString: String) -> UIColor? {
        return ColorConfiger.shared.colorFromRGB(hexString)
    }
    public static func reset(_ configer: ColorConfigerProtocol? = nil) {
        if let configer = configer ?? (ColorConfiger.shared as? ColorConfigerProtocol) {
            configer.resetColors(ColorConfiger.shared)
        }
    }
}
// MARK: - 
public struct Color {
    public static var black: UIColor = UIColor.black
    public static var darkGray: UIColor = UIColor.darkGray
    public static var lightGray: UIColor = UIColor.lightGray
    public static var white: UIColor = UIColor.white
    public static var gray: UIColor = UIColor.gray
    public static var red: UIColor = UIColor.red
    public static var green: UIColor = UIColor.green
    public static var blue: UIColor = UIColor.blue
    public static var cyan: UIColor = UIColor.cyan
    public static var yellow: UIColor = UIColor.yellow
    public static var magenta: UIColor = UIColor.magenta
    public static var orange: UIColor = UIColor.orange
    public static var purple: UIColor = UIColor.purple
    public static var brown: UIColor = UIColor.brown
    public static var clear: UIColor = UIColor.clear

    public static let darkBlack: UIColor = UIColor.black

}
extension Color {
    ///app主色调--蓝色
    public static var tintColor: UIColor = Color.yellow
    //    public static var selectedCell: UIColor = Color.colorFromRGB("#fffdef")!
    //控制器默认背景颜色

    ///黑色遮罩
    public static var blackMask: UIColor = darkBlack.withAlphaComponent(0.3)

    public static var viewBackground: UIColor = colorFromRGB("#F1F1F1")!
    //    public static var lightViewBackground: UIColor = Color.colorFromRGB("#f9f9f9")!
    ///分割线颜色
    public static var separatorLine: UIColor = colorFromRGB("#ebebeb")!
    ///边框颜色
    public static var boderLine: UIColor = separatorLine
    ///阴影颜色
    public static var shadow: UIColor = darkBlack
    ///不可用颜色
    public static var disable: UIColor = colorFromRGB("#CCCCCC")!
    ///占位颜色
    public static var placeholder: UIColor = colorFromRGB("#c7c7cd")!


    public struct List {}
}
