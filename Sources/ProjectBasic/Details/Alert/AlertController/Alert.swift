//
//  Alert.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/11.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

public var alertTitle: String = "温馨提示"
public var alertCancelTitle: String = "取消"
public var alertConfirmTitle: String = "确定"
public var alertIKnowTitle: String = "知道了"

public class Alert {

    fileprivate let alertController: UIAlertController

    init(title: String?, message: String?, preferredStyle: UIAlertController.Style) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    public static func alert(title: String? = alertTitle, message: String?) -> Alert {
        return Alert(title: title, message: message, preferredStyle: .alert)
    }
    public static func actionSheet(title: String? = alertTitle, message: String?) -> Alert {
        return Alert(title: title, message: message, preferredStyle: .actionSheet)
    }

}
extension Alert {
    public typealias AlertControllerClosureType = (UIAlertController, UIAlertAction) -> Void
    public typealias AlertControllerTextInputClosureType = (UIAlertController, UITextField) -> Void
    public func addCancelAction(title: String, _ closure: @escaping AlertControllerClosureType) -> Alert {
        let alertVC = self.alertController
        alertVC.addAction(UIAlertAction(title: title, style: .cancel, handler: {[weak alertVC] (action) in
            guard let alertVC = alertVC else { return }
            closure(alertVC, action)
        }))
        return self
    }
    public func addDefaultAction(title: String, _ closure: @escaping AlertControllerClosureType) -> Alert {
        let alertVC = self.alertController
        alertVC.addAction(UIAlertAction(title: title, style: .default, handler: {[weak alertVC] (action) in
            guard let alertVC = alertVC else { return }
            closure(alertVC, action)
        }))
        return self
    }
    public func addDestructiveAction(title: String, _ closure: @escaping AlertControllerClosureType) -> Alert {
        let alertVC = self.alertController
        alertVC.addAction(UIAlertAction(title: title, style: .destructive, handler: {[weak alertVC] (action) in
            guard let alertVC = alertVC else { return }
            closure(alertVC, action)
        }))
        return self
    }
    public func addTextInputAction(placeholder: String, _ closure: @escaping AlertControllerTextInputClosureType) -> Alert {
        let alertVC = self.alertController
        alertVC.addTextField {[weak alertVC] (textField) in
            guard let alertVC = alertVC else { return }
            textField.placeholder = placeholder
            closure(alertVC, textField)
        }
        return self
    }
}
extension Alert {
    func currentPresentedViewController(_ viewCon: UIViewController? = nil) -> UIViewController {
        let viewCon: UIViewController = viewCon ?? UIApplication.shared.delegate!.window!!.rootViewController!
        if let presentVC = viewCon.presentedViewController {
            return currentPresentedViewController(presentVC)
        } else {
            return viewCon
        }
    }
    public func show(in viewCon: UIViewController? = nil) {
//        if alertController.actions.first(where: {$0.style == .cancel}) == nil {
//            _ = self.addCancelAction(title: alertCancelTitle, { (action) in
//
//            })
//        }
        currentPresentedViewController(viewCon).present(alertController, animated: true, completion: nil)
    }
    public func hide() {
        self.alertController.dismiss(animated: true, completion: nil)
    }
}
extension Alert {
    public static func showPrompt(title: String = alertTitle, _ message: String, _ closure: AlertControllerClosureType? = nil) {
        Alert.alert(title: title, message: message).addDefaultAction(title: alertIKnowTitle) { (alertVC, action) in
            closure?(alertVC, action)
        }.show()
    }
    public static func showConfirm(title: String = alertTitle, _ message: String, _ closure: AlertControllerClosureType?) {
        self.showConfirm(title: title, message, closure, nil)
    }
    public static func showConfirm(title: String = alertTitle, _ message: String, _ closure: AlertControllerClosureType?, _  cancelClosure: AlertControllerClosureType?) {
        Alert.alert(title: title, message: message).addDefaultAction(title: alertConfirmTitle) { (alertVC, action) in
            closure?(alertVC, action)
            }.addCancelAction(title: alertCancelTitle) { (alertVC, action) in
                cancelClosure?(alertVC, action)
            }.show()
    }
}

import AudioToolbox
extension UIAlertController {
    convenience init(style: UIAlertController.Style, source: UIView? = nil, title: String? = nil, message: String? = nil, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: style)

        let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        let root = UIApplication.shared.keyWindow?.rootViewController?.view

        //self.responds(to: #selector(getter: popoverPresentationController))
        if let source = source {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = source.bounds
        } else if isPad, let source = root, style == .actionSheet {
            popoverPresentationController?.sourceView = source
            popoverPresentationController?.sourceRect = CGRect(x: source.bounds.midX, y: source.bounds.midY, width: 0, height: 0)
            //popoverPresentationController?.permittedArrowDirections = .down
            popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        }

        if let color = tintColor {
            self.view.tintColor = color
        }
    }
    public func show(animated: Bool = true, vibrate: Bool = false, style: UIBlurEffect.Style? = nil, completion: (() -> Void)? = nil) {
        if let style = style {
            for subview in view.allSubViewsOf(type: UIVisualEffectView.self) {
                subview.effect = UIBlurEffect(style: style)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
            if vibrate {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
        }
    }
    func addAction(image: UIImage? = nil, title: String, color: UIColor? = nil, style: UIAlertAction.Style = .default, isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
        //let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
        //let action = UIAlertAction(title: title, style: isPad && style == .cancel ? .default : style, handler: handler)
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled

        // button image
        if let image = image {
            action.setValue(image, forKey: "image")
        }

        // button title color
        if let color = color {
            action.setValue(color, forKey: "titleTextColor")
        }
        addAction(action)
    }
    func set(title: String?, font: UIFont, color: UIColor) {
        if title != nil {
            self.title = title
        }
        setTitle(font: font, color: color)
    }

    func setTitle(font: UIFont, color: UIColor) {
        guard let title = self.title else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: attributes)
        setValue(attributedTitle, forKey: "attributedTitle")
    }

    func set(message: String?, font: UIFont, color: UIColor) {
        if message != nil {
            self.message = message
        }
        setMessage(font: font, color: color)
    }

    func setMessage(font: UIFont, color: UIColor) {
        guard let message = self.message else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributedMessage = NSMutableAttributedString(string: message, attributes: attributes)
        setValue(attributedMessage, forKey: "attributedMessage")
    }

    func set(vc: UIViewController?, height: CGFloat? = nil) {
        guard let vc = vc else { return }
        setValue(vc, forKey: "contentViewController")
        if let height = height {
            vc.preferredContentSize.height = height
            preferredContentSize.height = height
        }
    }
}
