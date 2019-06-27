//
//  HUD.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2016/12/19.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

#if canImport(MBProgressHUD)
import Foundation
import MBProgressHUD
func rootWindow() -> UIWindow {
    return UIApplication.shared.delegate!.window!!
}

public class HUD {
    public init() {}
    fileprivate(set) lazy var _hud: JDProgressHUD = {
        let _hud = JDProgressHUD(frame: CGRect.zero)
        _hud.removeFromSuperViewOnHide = true
        return _hud
    }()
    public var text: String {
        get { return _hud.label.text ?? "" }
        set { _hud.label.text = newValue }
    }
    public var canInteractive: Bool {
        get { return _hud.canInteractive }
        set { _hud.canInteractive = newValue }
    }

    public func show(to view: UIView, animated: Bool = true) {
        _hud.show(to: view, animated: animated)
    }
    public func hide(hideType: HUDHideType = .fade, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        _hud.hide(hideType: hideType, delay: delay, completion: completion)
    }
}

extension HUD {
    @discardableResult
    public func showMessage(_ text: String, to view: UIView? = nil) -> HUD {
        DispatchQueue.main.async {
            self.text = text
            let view: UIView = view ?? rootWindow()
            self.show(to: view)
        }
        return self
    }
    @discardableResult
    public static func showMessage(_ text: String, to view: UIView? = nil) -> HUD {
        let hud = HUD()
        hud.showMessage(text, to: view)
        return hud
    }

}
extension HUD {
    public static func showSuccess(_ text: String, delay: TimeInterval = 1.5, to view: UIView? = nil) {
        self.showState(text, "success", delay, to: view)
    }
    public static func showInfo(_ text: String, delay: TimeInterval = 1.5, to view: UIView? = nil) {
        let info = "info"
        self.showState(text, image(info) != nil ? info : "success", delay, to: view)
    }
    public static func showError(_ text: String, delay: TimeInterval = 2.5, to view: UIView? = nil) {
        self.showState(text, "error", delay, to: view)
    }
    private static func showState(_ text: String, _ iconName: String, _ delay: TimeInterval, to view: UIView?) {
        DispatchQueue.main.async {
            let hud = HUD()
            hud.canInteractive = true
            hud._hud.hideWhenTap()
            hud._hud.detailsLabel.text = text
            if let image: UIImage = HUD.image(iconName) {
                let customView = UIImageView(image: image)
                hud._hud.customView = customView
            }
            hud._hud.mode = .customView
            hud._hud.offset.y = -50
            let view = view ?? rootWindow()
            hud.show(to: view)
            hud.hide(hideType: .falling, delay: delay)
        }
    }
    private static func image(_ name: String) -> UIImage? {
        return UIImage(named: "ic_hud_\(name)")
    }
}
extension HUD: Equatable {
    public static func == (lhs: HUD, rhs: HUD) -> Bool {
        return lhs._hud == rhs._hud
    }
}
extension HUD {
    private static var promptHUDArray = [HUD]()

    public static func showPrompt(_ text: String, to view: UIView? = nil) {
        DispatchQueue.main.async {
            let promptHUD = HUD()
            let _hud = promptHUD._hud
            _hud.canInteractive = true
            _hud.hideWhenTap()
            _hud.detailsLabel.text = text
            _hud.mode = .text
            _hud.margin = 10
            _hud.offset.y = {
                var offsetY = CGFloat(50 - promptHUDArray.count * 50)
                if offsetY < -150 {
                    offsetY = -150
                }
                return offsetY
            }()
            _hud.bezelView.style = .solidColor
            _hud.bezelView.color = Color.black
            _hud.bezelView.layer.borderWidth = 1
            _hud.bezelView.layer.borderColor = Color.white.cgColor
            _hud.detailsLabel.textColor = Color.white

            let view = view ?? rootWindow()
            promptHUDArray.append(promptHUD)
            promptHUD.show(to: view)
            promptHUD.hide(hideType: .falling, delay: 1.0, completion: { [weak promptHUD] in
                guard let promptHUD = promptHUD else { return }
                if let index = promptHUDArray.firstIndex(of: promptHUD) {
                    promptHUDArray.remove(at: index)
                }
            })
        }
    }
}
extension HUD {
    @discardableResult
    public func custom(_ closure: (MBBackgroundView) -> UIView) -> HUD {
        self._hud.margin = 0
        self._hud.mode = .customView
        self._hud.bezelView.style = .solidColor
        self._hud.bezelView.color = Color.clear
        self._hud.backgroundView.style = .solidColor
        self._hud.backgroundView.color = Color.black.withAlphaComponent(0.75)
        self._hud.customView = closure(self._hud.backgroundView)
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
#endif
