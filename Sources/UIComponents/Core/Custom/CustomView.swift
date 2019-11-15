//
//  CustomView.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/10/14.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

@IBDesignable
open class CustomView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configInit()
        self.viewDidLoad()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configInit()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.viewDidLoad()
    }
    open func configInit() {

    }
    open func viewDidLoad() {
        addChildView()
        configLayout()
    }
    open func addChildView() {}
    open func configLayout() {}

    // MARK: -
    public var didMoveToSuperviewClosure: (() -> Void)?
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMoveToSuperviewClosure?()
    }
    // MARK: - 便利方法
    public func change(frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    public func change(size: CGSize) -> Self {
        self.size = size
        return self
    }
    public func change(alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
}
