//
//  HUD.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2016/12/19.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation

func rootWindow() -> UIWindow {
    return UIApplication.shared.delegate!.window!!
}

public class HUD {
    public init() {}
    fileprivate(set) lazy var progressHUD: JDProgressHUD = {
        let progressHUD = JDProgressHUD(frame: CGRect.zero)
        progressHUD.removeFromSuperViewOnHide = true
        return progressHUD
    }()
    public var text: String {
        get {
            return self.progressHUD.label.text ?? ""
        }set {
            self.progressHUD.label.text = newValue
        }
    }

    public func show(to view: UIView, animated: Bool = true) {
        progressHUD.show(to: view, animated: animated)
    }
    public func hide(hideType: HUDHideType = .fade, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        progressHUD.hide(hideType: hideType, delay: delay, completion: completion)
    }

}

extension HUD {
    @discardableResult
    public func showMessage(_ text: String, to view: UIView? = nil, canInteractive: Bool = false) -> HUD {
        DispatchQueue.main.async {
            self.progressHUD.label.text = text
            self.progressHUD.canInteractive = canInteractive
            let view: UIView = view ?? rootWindow()
            self.show(to: view)

        }
        return self
    }
    @discardableResult
    public static func showMessage(_ text: String, to view: UIView? = nil, canInteractive: Bool = false) -> HUD {
        let hud = HUD()
        hud.showMessage(text, to: view, canInteractive: canInteractive)
        return hud
    }

}
extension HUD {
    private static func show(_ text: String, icon: String, delay: TimeInterval, to view: UIView?) {
        DispatchQueue.main.async {
            let hud = HUD()
            hud.progressHUD.canInteractive = true
            hud.progressHUD.hideWhenTap()
            hud.progressHUD.detailsLabel.text = text
            if let image: UIImage = UIImage(named: "MBProgressHUD.bundle/" + icon, in: Bundle(for: HUD.self), compatibleWith: nil) {
                hud.progressHUD.customView = UIImageView(image: image)
            }
            hud.progressHUD.mode = .customView
            hud.progressHUD.offset.y = -50
            let view = view ?? rootWindow()
            hud.show(to: view)
            hud.hide(hideType: .falling, delay: delay)
        }
    }
    public static func showSuccess(_ text: String, delay: TimeInterval = 1.5, to view: UIView? = nil) {
        self.show(text, icon: "success", delay: delay, to: view)
    }
    public static func showInfo(_ text: String, delay: TimeInterval = 1.5, to view: UIView? = nil) {
        self.show(text, icon: "success", delay: delay, to: view)
    }
    public static func showError(_ text: String, delay: TimeInterval = 2.5, to view: UIView? = nil) {
        self.show(text, icon: "error", delay: delay, to: view)
    }
}
extension HUD: Equatable {
    public static func == (lhs: HUD, rhs: HUD) -> Bool {
        return lhs.progressHUD == rhs.progressHUD
    }
}
extension HUD {
    private static var promptHUDArray = [HUD]()

    public static func showPrompt(_ text: String, to view: UIView? = nil) {
        DispatchQueue.main.async {
            let promptHUD = HUD()
            let prompt = promptHUD.progressHUD
            prompt.canInteractive = true
            prompt.hideWhenTap()
            prompt.detailsLabel.text = text
            prompt.mode = .text
            prompt.margin = 10
            prompt.offset.y = {
                var offsetY = CGFloat(50 - promptHUDArray.count * 50)
                if offsetY < -150 {
                    offsetY = -150
                }
                return offsetY
            }()
            prompt.bezelView.style = .solidColor
            prompt.bezelView.color = Color.black
            prompt.bezelView.layer.borderWidth = 1
            prompt.bezelView.layer.borderColor = Color.white.cgColor
            prompt.detailsLabel.textColor = Color.white

            let view = view ?? rootWindow()
            promptHUDArray.append(promptHUD)
            promptHUD.show(to: view)
            promptHUD.hide(hideType: .falling, delay: 1.0, completion: { [weak promptHUD] in
                guard let promptHUD = promptHUD else { return }
                if let index = promptHUDArray.index(of: promptHUD) {
                    promptHUDArray.remove(at: index)
                }
            })
        }
    }
}
extension HUD {
    @discardableResult
    public func custom(_ closure: (MBBackgroundView) -> UIView) -> HUD {
        self.progressHUD.margin = 0
        self.progressHUD.mode = .customView
        self.progressHUD.bezelView.style = .solidColor
        self.progressHUD.bezelView.color = Color.clear
        self.progressHUD.backgroundView.style = .solidColor
        self.progressHUD.backgroundView.color = Color.black.withAlphaComponent(0.75)
        self.progressHUD.customView = closure(self.progressHUD.backgroundView)
        return self
    }
    public static func showCustom(_ closure: @escaping (MBBackgroundView) -> UIView) -> HUD {
        let hud = HUD()
        DispatchQueue.main.async {
            hud.custom(closure)
            hud.show(to: rootWindow())
        }
        return hud
    }
}
