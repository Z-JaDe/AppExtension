//
//  Color.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 16/9/14.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
import CocoaExtension

public protocol ColorConfigerProtocol {
    func resetColors(_ configer: ColorConfiger)
}
public class ColorConfiger {
    fileprivate static let shared: ColorConfiger = ColorConfiger()
    private init() {}
    public final func colorFromRGB(_ hexInt: Int) -> UIColor {
        UIColor(hexInt: hexInt)
    }
    public final func colorFromRGB(_ hexString: String) -> UIColor? {
        UIColor(hexString: hexString)
    }
}
// MARK: -
extension Color {
    public static func colorFromRGB(_ hexInt: Int) -> UIColor {
        ColorConfiger.shared.colorFromRGB(hexInt)
    }
    public static func colorFromRGB(_ hexString: String) -> UIColor? {
        ColorConfiger.shared.colorFromRGB(hexString)
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
    /// app主色调--蓝色
    public static var tintColor: UIColor = Color.yellow
    //    public static var selectedCell: UIColor = Color.colorFromRGB(0xfffdef)
    // 控制器默认背景颜色

    /// 黑色遮罩
    public static var blackMask: UIColor = darkBlack.withAlphaComponent(0.3)

    public static var viewBackground: UIColor = colorFromRGB(0xF1F1F1)
    // public static var lightViewBackground: UIColor = Color.colorFromRGB(0xf9f9f9)
    /// 分割线颜色
    public static var separatorLine: UIColor = colorFromRGB(0xebebeb)
    /// 边框颜色
    public static var boderLine: UIColor = separatorLine
    /// 阴影颜色
    public static var shadow: UIColor = darkBlack
    /// 不可用颜色
    public static var disable: UIColor = colorFromRGB(0xCCCCCC)
    /// 占位颜色
    public static var placeholder: UIColor = colorFromRGB(0xc7c7cd)

    public struct List {}
}
