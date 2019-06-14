//
//  JDProgressHUD.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2016/12/28.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

#if canImport(MBProgressHUD)
import Foundation
import MBProgressHUD
public enum HUDHideType {
    case fade
    case falling
    case zoom
}
class JDProgressHUD: MBProgressHUD {
    var canInteractive: Bool = false
    let lock = NSRecursiveLock()
    lazy var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JDProgressHUD.tapHadle))

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if canInteractive {
            if bezelView.frame.contains(point) {
                return bezelView
            } else {
                return nil
            }
        } else {
            return super.hitTest(point, with: event)
        }
    }
    func hideWhenTap() {
        bezelView.addGestureRecognizer(tap)
    }
    @objc private func tapHadle() {
        hide(hideType: .zoom, delay: 0, completion: nil)
    }
    enum ShowState {
        case 已经隐藏
        case 正在显示
        case 正在隐藏
    }
    var showState: ShowState = .已经隐藏
    func show(to view: UIView, animated: Bool) {
        lock.lock(); defer {lock.unlock()}
        switch self.showState {
        case .已经隐藏, .正在隐藏:
            self.clearCompletionBlock()
            self.showState = .正在显示
            view.addSubview(self)
            self.frame = view.bounds
            self.animationType = .fade
            self.graceTime = 0.5
            super.show(animated: animated)
        case .正在显示:
            if view != self.superview {
                self.hide(hideType: .zoom, delay: 0) {
                    self.show(to: view, animated: animated)
                }
            } else {
                self.frame = view.bounds
            }
        }
    }
    func hide(hideType: HUDHideType, delay: TimeInterval, completion: (() -> Void)?) {
        lock.lock(); defer {lock.unlock()}
        super.completionBlock = { [weak self] in
            guard let self = self else { return }
            self.showState = .已经隐藏
            self.clearCompletionBlock()
            completion?()
        }
        self.showState = .正在隐藏
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            switch hideType {
            case .fade:
                self.animationType = .fade
                super.hide(animated: true)
            case .zoom:
                self.animationType = .zoomIn
                super.hide(animated: true)
            case .falling:
                UIView.animate(withDuration: 0.5, animations: {
                    self.bezelView.alpha = 0
                    self.offset.y = 200
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    super.hide(animated: false)
                    self.offset.y = 0
                    self.bezelView.alpha = 1
                })
            }
        }
    }

    @available(*, unavailable, message: "不能直接使用，应该使用上面自定义那个")
    override func show(animated: Bool) {
        super.show(animated: animated)
    }
    @available(*, unavailable, message: "不能直接使用，应该使用上面自定义那个")
    override func hide(animated: Bool) {
        super.hide(animated: animated)
    }
    @available(*, unavailable, message: "不能直接使用，应该使用上面自定义那个")
    override func hide(animated: Bool, afterDelay delay: TimeInterval) {
        super.hide(animated: animated, afterDelay: delay)
    }
    @available(*, unavailable, message: "不能直接使用")
    override var completionBlock: MBProgressHUDCompletionBlock? {
        get {return super.completionBlock}
        set {super.completionBlock = newValue}
    }
    func clearCompletionBlock() {
        super.completionBlock = nil
    }
}
#endif
