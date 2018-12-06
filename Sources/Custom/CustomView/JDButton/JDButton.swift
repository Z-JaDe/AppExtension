//
//  JDButton.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/20.
//

import UIKit
import SnapKit
extension UIControl.State: Hashable {
    public var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(self.rawValue)
        return hasher.finalize()
    }
}
open class JDButton: ImageLabelView {
    public convenience init(image: UIImage?, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setImage(image, for: .normal)
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    public convenience init(text: String, color: UIColor, font: UIFont, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setTitle(text, color, font, for: .normal)
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    // MARK: -
    private var titleFontInfo: [UIControl.State: UIFont] = [: ]
    private var titleColorInfo: [UIControl.State: UIColor] = [: ]
    private var attributedTitleInfo: [UIControl.State: NSAttributedString] = [: ]

    private var imageInfo: [UIControl.State: UIImage] = [: ]
    private var backgroundImageInfo: [UIControl.State: UIImage] = [: ]

    // MARK: -
    public override var image: UIImage? {
        get {return self.imageInfo[.normal]}
        set {self.setImage(newValue, for: .normal)}
    }
    public override var attributedTitle: NSAttributedString? {
        get {return self.attributedTitleInfo[.normal]}
        set {self.setAttributedTitle(newValue, for: .normal)}
    }
    public override var title: String? {
        get {return self.attributedTitleInfo[.normal]?.string}
        set {self.setTitle(newValue, for: .normal)}
    }
    public override var titleFont: UIFont? {
        get {return self.titleFontInfo[.normal]}
        set {self.setTitleFont(newValue, for: .normal)}
    }
    public override var titleColor: UIColor? {
        get {return self.titleColorInfo[.normal]}
        set {self.setTitleColor(newValue, for: .normal)}
    }

    internal override func config(imageView: ImageView) {
        imageView.image = self.imageInfo[self.state] ?? self.imageInfo[.normal]
    }
    internal override func config(titleLabel: Label) {
        titleLabel.attributedText = self.attributedTitleInfo[self.state] ?? self.attributedTitleInfo[.normal]
    }
    // MARK: -
    private var _backgroundImageView: ImageView?
    public var backgroundImageView: ImageView {
        if let result = _backgroundImageView {
            return result
        } else {
            let result = ImageView()
            _backgroundImageView = result
            config(backgroundImageView: result)
            return result
        }
    }
    private func config(backgroundImageView: ImageView) {
        backgroundImageView.image = self.backgroundImageInfo[self.state] ?? self.backgroundImageInfo[.normal]
    }
    func updateBackgroundLayout() {
        var layoutArr: [Constraint] = []
        if let backgroundImageView = _backgroundImageView, backgroundImageView.superview != nil {
            layoutArr += backgroundImageView.snp.prepareConstraints({ (maker) in
                maker.edges.equalToSuperview()
            })
        }
        self.updateLayouts(tag: "backgroundImageView", layoutArr)
    }

    // MARK: - UIButton
    open override var isSelected: Bool {
        didSet {
            updateData()
            updateContentItem()
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            updateData()
            updateContentItem()
        }
    }
    open override var isEnabled: Bool {
        didSet {
            updateData()
            updateContentItem()
        }
    }
    // MARK: -
    override func updateData() {
        super.updateData()
        if hasBackgroundImage {
            self.config(backgroundImageView: self.backgroundImageView)
        }
    }
    override var hasTitle: Bool {
        return self.attributedTitleInfo[self.state] != nil || self.attributedTitleInfo[.normal] != nil
    }
    override var hasImage: Bool {
        return self.imageInfo[self.state] != nil || self.imageInfo[.normal] != nil
    }
    var hasBackgroundImage: Bool {
        return self.backgroundImageInfo[self.state] != nil || self.backgroundImageInfo[.normal] != nil
    }
}
extension JDButton {
    public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        self.attributedTitleInfo[state] = title
        if self.state == state {
            updateData()
        }
        updateContentItem()
    }
    // ZJaDe: 
    public func setImage(_ image: UIImage?, for state: UIControl.State) {
        self.imageInfo[state] = image
        if self.state == state {
            updateData()
        }
        updateContentItem()
    }
    // ZJaDe: 
    public func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        self.backgroundImageInfo[state] = image
        if self.state == state {
            updateData()
        }
        updateBackgroundLayout()
    }
    public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        self.setBackgroundImage(UIImage.imageWithColor(color), for: .normal)
    }
}
extension JDButton {
    public func setTitle(_ title: String?, for state: UIControl.State) {
        if title != self.attributedTitleInfo[state]?.string {
            let titleFont = getTitleFont(state: state)
            let titleColor = getTitleColor(state: state)
            let attrStr: NSAttributedString? = {
                if let title = title {
                    return AttributedStringMaker(title).font(titleFont).color(titleColor).attr()
                } else {
                    return nil
                }
            }()
            self.setAttributedTitle(attrStr, for: state)
        }
    }
    public func setTitle(_ title: String?, _ color: UIColor?, _ font: UIFont?, for state: UIControl.State) {
        self.setTitle(title, for: state)
        self.setTitleColor(color, for: state)
        self.setTitleFont(font, for: state)
    }
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        self.titleColorInfo[state] = color
        let textColor = self.titleColorInfo[state] ?? self.titleColorInfo[.normal] ?? Color.black
        if let attr = self.attributedTitleInfo[state] {
            self.setAttributedTitle(AttributedStringMaker(attr).color(textColor).attr(), for: .normal)
        }
    }
    public func setTitleFont(_ font: UIFont?, for state: UIControl.State) {
        self.titleFontInfo[state] = font
        let titleFont = getTitleFont(state: state)
        if let attr = self.attributedTitleInfo[state] {
            self.setAttributedTitle(AttributedStringMaker(attr).font(titleFont).attr(), for: .normal)
        }
    }
    // MARK: -
    private func getTitleFont(state: UIControl.State) -> UIFont {
        return self.titleFontInfo[state] ?? self.titleFontInfo[.normal] ?? Font.h3
    }
    private func getTitleColor(state: UIControl.State) -> UIColor {
        return self.titleColorInfo[state] ?? self.titleColorInfo[.normal] ?? Color.black
    }
}
