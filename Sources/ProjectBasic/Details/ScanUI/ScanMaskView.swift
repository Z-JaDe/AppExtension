//
//  ScanMaskView.swift
//  ZJaDe
//
//  Created by ZJaDe on 2018/8/27.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public class ScanMaskView: CustomView {
    public let scanBoderView: ImageView = ImageView()
    public let lineLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    public override func configInit() {
        super.configInit()
        self.backgroundColor = Color.gray.alpha(0.2)
        self.layer.addSublayer(self.lineLayer)
        configObservable()
    }
    func configObservable() {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribeOnNext { [weak self] (_) in
                self?.resumeAnimation()
            }.disposed(by: self.disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .subscribeOnNext { [weak self] (_) in
                self?.stopAnimation()
            }.disposed(by: self.disposeBag)
    }
    public override func addChildView() {
        super.addChildView()
        self.addSubview(self.scanBoderView)
    }
    let imageLength: CGFloat = jd.screenWidth / 2 + 30
    let lineInset: CGFloat = 5
    public override func configLayout() {
        super.configLayout()
        self.scanBoderView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.height.equalTo(imageLength)
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.lineLayer.width = imageLength - lineInset * 2
        self.lineLayer.height = 2
        self.lineLayer.left = self.scanBoderView.left + lineInset
        self.lineLayer.top = self.scanBoderView.top + lineInset
    }

    // MARK: -
    public func stopAnimation() {
        self.lineLayer.removeAnimation(forKey: "translationY")
    }
    public func resumeAnimation() {
        let basic = CABasicAnimation(keyPath: "transform.translation.y")
        basic.fromValue = 0
        basic.toValue = imageLength - lineInset * 2
        basic.duration = 2
        basic.repeatCount = Float.greatestFiniteMagnitude
        self.lineLayer.add(basic, forKey: "translationY")
    }
}
