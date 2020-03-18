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
    fileprivate(set) lazy var unwrap: JDProgressHUD = {
        let unwrap = JDProgressHUD(frame: CGRect.zero)
        unwrap.removeFromSuperViewOnHide = true
        return unwrap
    }()
    public var text: String {
        get { unwrap.label.text ?? "" }
        set { unwrap.label.text = newValue }
    }
    public var canInteractive: Bool {
        get { unwrap.canInteractive }
        set { unwrap.canInteractive = newValue }
    }

    public func show(to view: UIView, animated: Bool = true) {
        unwrap.show(to: view, animated: animated)
    }
    public func hide(hideType: HUDHideType = .fade, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        unwrap.hide(hideType: hideType, delay: delay, completion: completion)
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
    public struct State {
        public var icon: UIImage?
        public var duration: TimeInterval
        public static var success: State = State(icon: UIImage(named: "icunwrap_success"), duration: 1.5)
        public static var info: State = State(icon: UIImage(named: "icunwrap_info"), duration: 1.5)
        public static var error: State = State(icon: UIImage(named: "icunwrap_error"), duration: 2.5)
    }
    public static func showSuccess(_ text: String, duration: TimeInterval? = nil, to view: UIView? = nil) {
        showState(text, State.success, duration, to: view)
    }
    public static func showInfo(_ text: String, duration: TimeInterval? = nil, to view: UIView? = nil) {
        showState(text, State.info, duration, to: view)
    }
    public static func showError(_ text: String, duration: TimeInterval? = nil, to view: UIView? = nil) {
        showState(text, State.error, duration, to: view)
    }
    private static func showState(_ text: String, _ state: State, _ duration: TimeInterval?, to view: UIView?) {
        DispatchQueue.main.async {
            let hud = HUD()
            hud.canInteractive = true
            hud.unwrap.hideWhenTap()
            hud.unwrap.detailsLabel.text = text
            if let icon = state.icon {
                hud.unwrap.customView = UIImageView(image: icon)
            }
            hud.unwrap.mode = .customView
            hud.unwrap.offset.y = -50
            let view = view ?? rootWindow()
            hud.show(to: view)
            hud.hide(hideType: .falling, delay: duration ?? state.duration)
        }
    }
}
extension HUD: Equatable {
    public static func == (lhs: HUD, rhs: HUD) -> Bool {
        lhs.unwrap == rhs.unwrap
    }
}
extension HUD {
    private static var promptHUDArray = [HUD]()

    public static func showPrompt(_ text: String, to view: UIView? = nil) {
        DispatchQueue.main.async {
            let promptHUD = HUD()
            let unwrap = promptHUD.unwrap
            unwrap.canInteractive = true
            unwrap.hideWhenTap()
            unwrap.detailsLabel.text = text
            unwrap.mode = .text
            unwrap.margin = 10
            unwrap.offset.y = {
                var offsetY = CGFloat(50 - promptHUDArray.count * 50)
                if offsetY < -150 {
                    offsetY = -150
                }
                return offsetY
            }()
            unwrap.bezelView.style = .solidColor
            unwrap.bezelView.color = Color.black
            unwrap.bezelView.layer.borderWidth = 1
            unwrap.bezelView.layer.borderColor = Color.white.cgColor
            unwrap.detailsLabel.textColor = Color.white

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
        unwrap.margin = 0
        unwrap.mode = .customView
        unwrap.bezelView.style = .solidColor
        unwrap.bezelView.color = Color.clear
        unwrap.backgroundView.style = .solidColor
        unwrap.backgroundView.color = Color.black.withAlphaComponent(0.75)
        unwrap.customView = closure(unwrap.backgroundView)
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
