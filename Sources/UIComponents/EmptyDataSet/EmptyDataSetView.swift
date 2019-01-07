//
//  EmptyDataSetView.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/18.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit

public enum EmptyViewState {
    case noload
    case loading
    case loaded
    case loadFailed
}

public enum EmptyShowType {
    case automatic
    case show
    case hide
}

public class EmptyDataSetView: CustomView {
    public typealias ContentType = EmptyDataSetContentView
    public typealias EmptyDataSetClosureType = (EmptyViewState, ContentType) -> Void
    public var contentItem: ContentType = ContentType()

    /// ZJaDe: 根据加载状态重写 优先级最高
    public var contentClosure: EmptyDataSetClosureType? {
        didSet {reloadData()}
    }
    public weak var delegate: EmptyDataSetContentProtocol?

    public override func configInit() {
        super.configInit()
        reloadData()
    }
    public override func addChildView() {
        super.addChildView()
        self.addSubview(self.contentItem)
        self.contentItem.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }
    // MARK: -
    var emptyStateChanged: CallBack<EmptyViewState>?
    public var emptyState: EmptyViewState = .noload {
        didSet {
            self.emptyStateChanged?(self.emptyState)
        }
    }
    public var showType: EmptyShowType = .automatic {
        didSet {reloadData()}
    }

    weak var container: EmptyDataSetProtocol?
    public func checkCanShow() -> Bool {
        switch self.showType {
        case .automatic:
            return self.container?.isEmptyData ?? false
        case .show:
            return true
        case .hide:
            return false
        }
    }

}
extension EmptyDataSetView {
    public func reloadData() {
        self.prepareForReuse()
        if checkCanShow() {
            if let contentClosure = contentClosure {
                contentClosure(self.emptyState, contentItem)
            } else {
                configEmptyDataSetData(self.emptyState)
            }
            self.contentItem.setNeedsLayout()
            if self.contentItem.superview != nil {
                self.contentItem.layoutIfNeeded()
            }
            self.contentViewAnimate(show: true)
        } else {
            self.contentViewAnimate(show: false) { (_) in
                if self.checkCanShow() == false {
                    self.removeFromSuperview()
                }
            }
        }
    }
}
extension EmptyDataSetView {
    func prepareForReuse() {
        _cleanState()
    }
    func contentViewAnimate(show: Bool, completion: ((Bool) -> Void)? = nil) {
        if show {
            let animater: Animater = Animater().animations {
                self.contentItem.alpha = 1
                self.contentItem.transform = CGAffineTransform.identity
            }
            if let completion = completion {
                _ = animater.completion(completion)
            }
            animater.spring()
        } else {
            let animater: Animater = Animater().animations {
                self.contentItem.alpha = 0
                self.contentItem.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            if let completion = completion {
                _ = animater.completion(completion)
            }
            animater.spring()
        }
    }
}
extension EmptyDataSetView {
    private func _cleanState() {
        self.delegate?.cleanState(self)
        (self as? EmptyDataSetContentProtocol)?.cleanState(self)
        self.contentItem.cleanState()
    }
    func configEmptyDataSetData(_ state: EmptyViewState) {
        switch state {
        case .noload:
            break
        case .loading:
            if let delegate = self.delegate {
                delegate.configEmptyDataSetLoading(self)
            } else {
                _configEmptyDataSetLoading(contentItem)
            }
        case .loadFailed:
            if let delegate = self.delegate {
                delegate.configEmptyDataSetLoadFailed(self)
            } else {
                _configEmptyDataSetLoadFailed(contentItem)
            }
        case .loaded:
            if let delegate = self.delegate {
                delegate.configEmptyDataSetNoData(self)
            } else {
                _configEmptyDataSetNoData(contentItem)
            }
        }
    }
}
