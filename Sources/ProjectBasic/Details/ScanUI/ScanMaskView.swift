//
//  ScanMaskView.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/8/27.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

class ScanMaskView: CustomView {
    public let scanBoderView: ImageView = ImageView()
    public let lineLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    override func configInit() {
        super.configInit()
        self.backgroundColor = Color.gray.alpha(0.2)
        self.layer.addSublayer(self.lineLayer)
    }
    func configObservable() {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribeOnNext { (_) in
                self.resumeAnimation()
            }.disposed(by: self.disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .subscribeOnNext { (_) in
                self.stopAnimation()
            }.disposed(by: self.disposeBag)
    }
    override func addChildView() {
        super.addChildView()
        self.addSubview(self.scanBoderView)
    }
    let imageLength: CGFloat = jd.screenWidth / 2 + 30
    let lineInset: CGFloat = 5
    override func configLayout() {
        super.configLayout()
        self.scanBoderView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(imageLength)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lineLayer.width = imageLength - lineInset * 2
        self.lineLayer.height = 2
        self.lineLayer.left = self.scanBoderView.left + lineInset
        self.lineLayer.top = self.scanBoderView.top + lineInset
    }

    // MARK: -
    func stopAnimation() {
        self.lineLayer.removeAnimation(forKey: "translationY")
    }
    func resumeAnimation() {
        let basic = CABasicAnimation(keyPath: "transform.translation.y")
        basic.fromValue = 0
        basic.toValue = imageLength - lineInset * 2
        basic.duration = 2
        basic.repeatCount = Float.greatestFiniteMagnitude
        self.lineLayer.add(basic, forKey: "translationY")
    }
}
