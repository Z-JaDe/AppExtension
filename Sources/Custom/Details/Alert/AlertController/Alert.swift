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
    public func show() {
//        if alertController.actions.first(where: {$0.style == .cancel}) == nil {
//            _ = self.addCancelAction(title: alertCancelTitle, { (action) in
//                
//            })
//        }
        func currentPresentedViewController(_ viewCon: UIViewController? = nil) -> UIViewController {
            let viewCon: UIViewController = viewCon ?? UIApplication.shared.delegate!.window!!.rootViewController!
            if let presentVC = viewCon.presentedViewController {
                return currentPresentedViewController(presentVC)
            } else {
                return viewCon
            }
        }
        currentPresentedViewController().present(alertController, animated: true, completion: {

        })
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
