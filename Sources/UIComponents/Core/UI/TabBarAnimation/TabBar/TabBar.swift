//
//  TabBar.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/9/21.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit

open class TabBar: UITabBar {

    open override var selectedItem: UITabBarItem? {
        didSet { self.currentItem = selectedItem as? TabBarItem }
    }
    private var currentItem: TabBarItem? {
        didSet {
            guard let currentItem = self.currentItem else { return }
//            guard oldValue != currentItem else { return }
            changeItem(oldValue, toItem: currentItem)
            let index = items?.firstIndex(of: currentItem) ?? 0
            changeCurrentLayerFrame(barButton: tabBarButtonArr[index])
        }
    }

    open var selectedLayerBackgroundColor: UIColor? {
        didSet { currentLayer.backgroundColor = selectedLayerBackgroundColor?.cgColor }
    }
    open var jdSeparatorLineColor: UIColor? {
        didSet { shadowImage = UIImage.create(color: jdSeparatorLineColor) }
    }
    open var jdBackgroundColor: UIColor? {
        didSet { backgroundImage = UIImage.create(color: jdBackgroundColor) }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configInit()
    }
    func configInit() {
        self.selectedLayerBackgroundColor = Color.white
        self.jdSeparatorLineColor = Color.red
        self.jdBackgroundColor = Color.colorFromRGB("#ECECEC")
        self.layer.addSublayer(self.currentLayer)
    }
    var currentLayer: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 24
        return layer
    }()

    override open func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        guard let items = items as? [TabBarItem] else {
            return
        }
        self.currentItem = (self.selectedItem as? TabBarItem) ?? items.first
        self.setNeedsLayout()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        /// ZJaDe: 把可选的items 转化成 [TabBarItem]
        let items = self.items as? [TabBarItem]
        items?.lazy.enumerated().forEach({ (offset, tabBarItem) in
            let itemView = tabBarItem.itemView
            let tabbarButton = tabBarButtonArr[offset]
            tabbarButton.tag = barButtonTag(index: offset)
            if itemView.superview != tabbarButton {
                tabbarButton.addSubview(itemView)
            }
            itemView.frame = tabbarButton.bounds
        })
    }
    var tabBarButtonArr: [UIView] {
        let cls: AnyClass = NSClassFromString("UITabBarButton")!
        return self.subviews.filter {$0.isKind(of: cls)}.sorted {$0.frame.origin.x < $1.frame.origin.x}
    }
}
extension TabBar {
//    @objc func didSelect(barButton: UIControl) {
//        //        guard self.canTap else {
//        //            return
//        //        }
//        //        self.canTap = false
//        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//        //            self.canTap = true
//        //        }
//        guard let items = self.items as? [TabBarItem] else {
//            return
//        }
//        self.currentItem = items[barButtonIndex(tag: barButton.tag)]
//    }
    func changeItem(_ fromItem: TabBarItem?, toItem: TabBarItem) {
        fromItem?.deselectAnimation()
        toItem.selectAnimation()
    }
    func changeCurrentLayerFrame(barButton: UIView) {
        self.currentLayer.frame = barButton.frame
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        animation.values = [1.0, 1.25, 0.9, 1.15, 0.95, 1.02, 1.0]
        animation.duration = TimeInterval(0.5)
        animation.calculationMode = CAAnimationCalculationMode.cubic
        self.currentLayer.add(animation, forKey: nil)
    }
}
extension TabBar {
    func barButtonIndex(tag: Int) -> Int {
        tag - 20
    }
    func barButtonTag(index: Int) -> Int {
        index + 20
    }
}
