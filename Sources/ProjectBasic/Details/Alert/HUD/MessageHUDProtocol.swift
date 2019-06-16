//
//  MessageHUDProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

#if canImport(MBProgressHUD)
import Foundation
extension UIViewController: MessageHUDProtocol {}
public protocol MessageHUDProtocol: AssociatedObjectProtocol {
    func showMessage(_ message: String) -> HUD
    func resetMessage(_ message: String) -> HUD
    func hideMessage(_ message: String)

    func showSuccess(_ text: String)
    func showSuccess(_ text: String, delay: TimeInterval)
    func showError(_ text: String)
    func showError(_ text: String, delay: TimeInterval)
}
private var hudKey: UInt8 = 0
private var messageArrKey: UInt8 = 0
extension MessageHUDProtocol {
    private var hud: HUD {
        return associatedObject(&hudKey, createIfNeed: HUD())
    }
    private var messageArr: [String] {
        get {return associatedObject(&messageArrKey, createIfNeed: [])}
        set {setAssociatedObject(&messageArrKey, newValue)}
    }
}
extension MessageHUDProtocol where Self: UIViewController {
    fileprivate func show() {
        DispatchQueue.main.async {
            self.hud._hud.label.numberOfLines = 0
            self.hud.text = self.messageArr.last ?? ""
            self.hud.show(to: self.view)
        }
    }
    fileprivate func hide() {
        DispatchQueue.main.async {
            self.hud.hide(hideType: .fade)
        }
    }
    fileprivate func update() {
        if self.messageArr.isNotEmpty {
            self.show()
        } else {
            self.hide()
        }
    }
}
public extension MessageHUDProtocol where Self: UIViewController {
    @discardableResult
    func showMessage(_ message: String) -> HUD {
        self.messageArr.append(message)
        self.show()
        return self.hud
    }
    @discardableResult
    func resetMessage(_ message: String) -> HUD {
        self.messageArr = [message]
        self.show()
        return self.hud
    }

    func hideMessage(_ message: String = "") {
        if let index = self.messageArr.firstIndex(of: message) {
            self.messageArr.remove(at: index)
        } else {
            _ = self.messageArr.popLast()
        }
        self.update()
    }

    func showSuccess(_ text: String) {
        HUD.showSuccess(text, to: self.view)
    }
    func showSuccess(_ text: String, delay: TimeInterval) {
        HUD.showSuccess(text, delay: delay, to: self.view)
    }
    func showError(_ text: String) {
        HUD.showError(text, to: self.view)
    }
    func showError(_ text: String, delay: TimeInterval) {
        HUD.showError(text, delay: delay, to: self.view)
    }
}
#endif
