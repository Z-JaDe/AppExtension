//
//  ModalViewController.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/10/26.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import ModalManager
import RxSwift

open class BlurModalViewController: ModalViewController {
    open override var presentationControllerClass: PresentationController.Type {
        BlurPresentationController.self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        if needObserverKeyboard {
            observeKeyboardWillChangeFrame()
        }
    }
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        checkUpdateContentViewBottom()
    }

    var keyboardValues: (offset: CGFloat, duration: TimeInterval) = (0, 0)
    func checkUpdateContentViewBottom() {
        DispatchQueue.main.async {
            if self.state == .已经显示 && self.needObserverKeyboard {
                self.updateContentViewBottom(self.keyboardValues.duration)
            }
        }
    }

    open override func presentedViewFrame(_ containerViewBounds: CGRect, _ presentedViewContentSize: CGSize) -> CGRect {
        var result = super.presentedViewFrame(containerViewBounds, presentedViewContentSize)
        if self.keyboardValues.offset > 0 {
            result = result.offsetBy(dx: 0, dy: -self.offSetWhenKeyboard)
        }
        return result
    }
    // MARK: -
    /// ZJaDe: 返回是否需要监听键盘弹出
    open var needObserverKeyboard: Bool {
        false
    }
    /// ZJaDe: 返回键盘弹出时偏移量
    open var offSetWhenKeyboard: CGFloat {
        self.keyboardValues.offset
    }
}
extension BlurModalViewController {
    func observeKeyboardWillChangeFrame() {
        /// ZJaDe: 因为有可能出现显示控制器的过程中 键盘弹出的情况 所以需要添加一个keyboardHeightSubject 做个中转
        NotificationCenter.default.rx.notificationKeyboardWillChangeFrame()
            .subscribeOnNext {[weak self] (arg) in
                guard let self = self else { return }
                let (beginFrame, endFrame, animationDuration) = arg
                let height = endFrame.size.height
                let keyboardHeight: CGFloat
                if beginFrame.origin.y == jd.screenHeight {
                    keyboardHeight = height
                } else if endFrame.origin.y == jd.screenHeight {
                    keyboardHeight = 0
                } else {
                    keyboardHeight = height
                }
                self.keyboardValues = (keyboardHeight, animationDuration)
                self.checkUpdateContentViewBottom()
            }.disposed(by: self.disposeBag)
    }
    func updateContentViewBottom(_ animationDuration: TimeInterval) {
        Animater().duration(animationDuration).animations {
            self.updateViewsFrame()
        }.animate()
    }
}
open class BlurPresentationController: PresentationController {
    //    fileprivate let dimmingBgView: ImageView = ImageView()
    let effectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        effectView.alpha = 0.9
        return effectView
    }()
    open override func createDimmingView() -> PresentationController.DimmingView {
        let result = super.createDimmingView()
        result.backgroundColor = Color.clear
        result.addSubview(effectView)
        effectView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        return result
    }

    open override func showDimmingViewAnimate(_ dimmingView: DimmingView) {
        effectView.effect = nil
        animate {
            self.effectView.effect = UIBlurEffect(style: .dark)
        }
    }
    open override func hideDimmingViewAnimate(_ dimmingView: PresentationController.DimmingView) {
        animate {
            self.effectView.effect = nil
        }
    }
}

// MARK: - 截图旧代码
//    open override func presentationTransitionWillBegin() {
//        super.presentationTransitionWillBegin()
//        screenshots()
//    }
//
//    func screenshots() {
//        guard let container = getPresenting as? ModalContainerScreenshotsProtocol else { return }
//        Observable<Int>.timer(0.1, period: 0.5, scheduler: MainScheduler.asyncInstance)
//            .take(5)
//            .subscribeOnNext {[weak self] (_) in
//                guard let self = self else { return }
//                let dimmingBgView = self.gaussianBlurPresentationCon?.dimmingBgView
//                if let image = container.screenshotsImage()?.blurImage(tintColor: Color.blackMask) {
//                    dimmingBgView?.image = image
//                    self.resetDisposeBagWithTag("_screenshotsImage")
//                }
//            }.disposed(by: self.disposeBagWithTag("screenshotsImage"))
//    }
//public protocol ModalContainerScreenshotsProtocol: class {
//    func screenshotsImage() -> UIImage?
//}
//extension ModalContainerScreenshotsProtocol where Self: UIViewController {
//    public func screenshotsImage() -> UIImage? {
//        if self.view.subviews.isNotEmpty {
//            return self.view.toImage()
//        } else {
//            return nil
//        }
//    }
//}
//extension NavItemSingleContainerViewController {
//    public func screenshotsImage() -> UIImage? {
//        if self.contentView.subviews.isNotEmpty {
//            return self.contentView.toImage()
//        } else {
//            return nil
//        }
//    }
//}
