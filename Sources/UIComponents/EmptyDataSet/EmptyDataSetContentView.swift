//
//  EmptyDataSetContentView.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/20.
//

import UIKit

public class EmptyDataSetContentView: CustomView {
    public private(set) lazy var button: JDButton = {
        let button = JDButton()
        button.imageAlignment = .begin
        button.contentStackView.axis = .vertical
        button.contentStackView.spacing = 10
        return button
    }()
    public func addButtonIfNeed(_ layoutClosure: () -> Void) {
        if self.button.superview == nil {
            self.addSubview(self.button)
        }
        layoutClosure()
        self.button.isHidden = false
    }
    // MARK: -
    /// ZJaDe: 设置成ActivityIndicator
    public func configActivityIndicator(_ activityIndicatorStyle: UIActivityIndicatorView.Style) {
        addActivityIndicatorIfNeed()
        self.activityIndicator.style = activityIndicatorStyle
        self.activityIndicator.startAnimating()
    }
    lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    func addActivityIndicatorIfNeed() {
        if self.activityIndicator.superview == nil {
            self.addSubview(self.activityIndicator)
            NSLayoutConstraint.activate(
                activityIndicator.equalToSuperview(.center)
                + activityIndicator.innerToSuperview([.left, .top])
            )
        }
        self.activityIndicator.isHidden = false
    }
    // MARK: -
    public func cleanState() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.button.isHidden = true
    }
}
extension EmptyDataSetContentView {
    public func addButtonIfNeed() {
        self.addButtonIfNeed {
            self.button.updateLayouts(
                tag: "remove",
                self.button.equalToSuperview(.center)
                + self.button.innerToSuperview([.left, .top])
            )
        }
    }
    /// ZJaDe: 设置成一个文本
    public func configLabel(_ text: String, color: UIColor = Color.black, font: UIFont = Font.h1) {
        self.button.setTitle(text, color, font, for: .normal)
        self.button.setImage(nil, for: .normal)
    }
    /// ZJaDe: 设置成一个图片
    public func configImage(_ image: UIImage) {
        self.button.setTitle(nil, for: .normal)
        self.button.setImage(image, for: .normal)
    }
    /// ZJaDe: 设置成一个图片+文本
    public func config(_ closure: (JDButton) -> Void) {
        closure(self.button)
    }
}
