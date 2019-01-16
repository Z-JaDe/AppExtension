//
//  NavigationItemProtocol.swift
//  JDNavigationController
//
//  Created by 茶古电子商务 on 16/9/22.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public enum NavBarShadowType {
    case shadow(UIColor)
    case separatorLine(UIColor)
    case `default`
    case none
}

public protocol NavigationItemProtocol: class {
    var navBarIsHidden: Bool {get}
    var navBarTintColor: UIColor {get}
    var navTintColor: UIColor {get}
    /// ZJaDe: 更新时要控制不能超过1，一旦超过1 isTranslucent会自动设置成false
    var navBarAlpha: CGFloat {get}
    var navBarBackgroundImage: UIImage? {get}
    var navBarShadowType: NavBarShadowType {get}
    var titleTextAttributes: [NSAttributedString.Key : Any] {get set}

    func updateNavBar(isDidAppear: Bool)
}

extension NavigationItemProtocol where Self: UIViewController {
    public func updateNavBar(isDidAppear: Bool) {
        guard checkVCType() else {return}
        self.updateBarStyle()
        self.changeTitleTextAttributes(self.titleTextAttributes)
        self.changeTintColor(self.navTintColor)
        self.changeIsHidden(self.navBarIsHidden, isDidAppear)
    }
}

public extension NavigationItemProtocol where Self: UIViewController {
    func changeTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        guard checkVCType() else {return}
        guard let navBar = self.navigationController?.navigationBar else {return}
        var attributes = attributes
        if attributes[.foregroundColor] == nil {
            attributes[.foregroundColor] = self.navTintColor
        }
        navBar.titleTextAttributes = attributes
    }
    func changeTintColor(_ color: UIColor) {
        guard checkVCType() else {return}
        guard let navBar = self.navigationController?.navigationBar else {return}

        navBar.changeTintColor(color)
    }
    func changeIsHidden(_ isHidden: Bool, _ isDidAppear: Bool) {
        guard checkVCType() else {return}
        if isDidAppear {
            self.navigationController?.isNavigationBarHidden = isHidden
        } else {
            self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        }
    }
    /// ZJaDe: 
    func updateBarStyle() {
        guard checkVCType() else {return}
        guard let navBar = self.navigationController?.navigationBar else {return}

        navBar.changeBarTintColor(self.navBarTintColor, self.navBarBackgroundImage, self.navBarShadowType, self.navBarAlpha)
        navBar.changeShadow(self.navBarShadowType, self.navBarAlpha)
    }

//    private func changeAlpha(_ alpha: CGFloat) {
//        guard checkVCType() else {return}
//        guard let navBar = self.navigationController?.navigationBar else {return}
//
//        navBar.changeAlpha(alpha)
//        if alpha == 0 {
//            updateBarStyle()
//        }
//    }
//    private func changeTitleAlpha(_ alpha: CGFloat) {
//        guard checkVCType() else {return}
//        guard let navBar = self.navigationController?.navigationBar else {return}
//
//        navBar.changeTitleAlpha(alpha)
//    }
}
extension UIViewController {
    func checkVCType() -> Bool {
        guard self.parent is UINavigationController || self.parent is UITabBarController else {
            return false
        }
        return true
    }
}

extension UINavigationBar {
    /** ZJaDe: 
     isTranslucent
     默认情况：
        默认为true
        如果设置了背景图片，图片的任何一个像素透明有小于1的情况，为true，否则为false
     如果手动设置了true，却设置了不透明的背景图片 ->
        导航栏会自动把图片改成一个透明度小于1的
     如果手动设置了false，却设置了透明的背景图片 ->
        如果设置了barTintColor，导航栏会给这个图像提供一个barTintColor颜色的背景
        如果barTintColor为nil，颜色会根据barStyle，black时是黑色，default时是白色
     /// ZJaDe: 测试
     isTranslucent为false时，_UIBarBackground的背景色会是barTintColor, 或者根据barStyle是黑色白色，并且color的alpha无效；此时就算设置了backgroundImage，也只是在_UIBarBackground上面铺了一层图片，还是不透明的
     isTranslucent为true时，_UIBarBackground没有颜色: 
        如果设置了backgroundImage，显示
        _UIBarBackground -> backgroundImage
        如果没有设置backgroundImage，显示
        _UIBarBackground -> UIVisualEffectView -> _UIVisualEffectSubview的背景颜色为
        black(White: 0.11 Alpha: 0.73)
        default(White: 0.97 Alpha: 0.8)
        barTintColor(Alpha: 0.1, viewAlpha: 0.850000023841858)
        如果设置了barTintColor，_UIVisualEffectBackdropView在视图预览上看着和barStyle对应颜色差不多
     */

    func changeShadow(_ shadowType: NavBarShadowType, _ alpha: CGFloat) {
        switch shadowType {
        case .none:
            self.shadowImage = UIImage()
            self.addShadow(offset: CGSize.zero, color: Color.clear, opacity: 0, radius: 0)
        case .shadow(let color):
            self.shadowImage = UIImage()
            self.addShadow(offset: CGSize.zero, color: color, opacity: 0.3 * Float(alpha), radius: 5)
        case .default:
            self.shadowImage = nil
            self.addShadow(offset: CGSize.zero, color: Color.clear, opacity: 0, radius: 0)
        case .separatorLine(let color):
            let color = color.alpha(color.alpha * alpha)
            self.shadowImage = UIImage.imageWithColor(color, size: CGSize(width: jd.screenWidth, height: 0.5))
            self.addShadow(offset: CGSize.zero, color: Color.clear, opacity: 0, radius: 0)
        }

    }
//    @objc func changeAlpha(_ alpha: CGFloat) {
//        self.jd_backgroundView?.alpha = alpha
//    }
//    @objc func changeTitleAlpha(_ alpha: CGFloat) {
//        if let titleView = self.topItem?.titleView {
//            titleView.alpha = alpha
//        }
//    }
    @objc func changeTintColor(_ color: UIColor) {
        self.tintColor = color
        self.setNeedsDisplay()
        if let titleView = self.topItem?.titleView {
            let scale: Float = color == Color.white ? 1.0 : 0.0
            titleView.addTitleShadow(scale: scale)
        }
    }
    func updateIsTranslucent(_ alpha: CGFloat) {
        if alpha > 1 {
            self.isTranslucent = false
        } else {
            self.isTranslucent = true
        }
    }
    func changeBarTintColor(_ color: UIColor, _ backgroundImage: UIImage?, _ shadowType: NavBarShadowType, _ alpha: CGFloat) {
        updateIsTranslucent(alpha)
        let color = color.alpha(alpha)
        self.barTintColor = color
        if let backgroundImage = backgroundImage {
            setBackgroundImage(backgroundImage.alpha(alpha), for: .default)
        } else {
            let backgroundImage = UIImage.imageWithColor(color)
            if self.isTranslucent == false {/// ZJaDe: 不透明的情况
                setBackgroundImage(self.shadowImage.flatMap({_ in backgroundImage}), for: .default)
            } else {
                setBackgroundImage(backgroundImage, for: .default)
            }
        }
    }
}
