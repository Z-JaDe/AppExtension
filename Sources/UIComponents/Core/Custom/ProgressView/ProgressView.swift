//
//  ProgressView.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/5/28.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

/** ZJaDe: 
 ProgressLayer 尺寸和cornerRadius由内部控制
 */
open class ProgressView: CustomView {

    public var progress: CGFloat = 0 {
        didSet {
            progress = progress.clamp(min: 0, max: 1)
            updateProgress()
        }
    }
    public var progressLayer: CALayer = CALayer() {
        didSet {
            oldValue.removeFromSuperlayer()
            changedProgress()
        }
    }

    open override func configInit() {
        super.configInit()
        self.backgroundColor = Color.clear
        self.progressLayer.backgroundColor = Color.tintColor.cgColor
        changedProgress()
    }
    open override func addChildView() {
        super.addChildView()
    }
    func changedProgress() {
        self.layer.addSublayer(self.progressLayer)
        updateProgress()
    }
    open override var intrinsicContentSize: CGSize {
        CGSize(width: jd.screenWidth, height: 4)
    }
    // MARK: -
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateProgress()
    }
    func updateProgress() {
        let rect = self.bounds
        self.progressLayer.height = rect.size.height
        self.progressLayer.width = rect.size.width * self.progress
        self.progressLayer.origin = CGPoint.zero
        self.progressLayer.cornerRadius = self.layer.cornerRadius
    }
}
