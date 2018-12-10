//
//  EmptyDataSetContentProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/5.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol EmptyDataSetContentProtocol: class {
    typealias ContainerView = EmptyDataSetView
    func configEmptyDataSetLoadFailed(_ containerView: ContainerView)
    func configEmptyDataSetLoading(_ containerView: ContainerView)
    func configEmptyDataSetNoData(_ containerView: ContainerView)
    func cleanState(_ containerView: ContainerView)
}
public extension EmptyDataSetContentProtocol {
    func configEmptyDataSetLoadFailed(_ containerView: ContainerView) {
        containerView._configEmptyDataSetLoadFailed(containerView.contentItem)
    }
    func configEmptyDataSetLoading(_ containerView: ContainerView) {
        containerView._configEmptyDataSetLoading(containerView.contentItem)
    }
    func configEmptyDataSetNoData(_ containerView: ContainerView) {
        containerView._configEmptyDataSetNoData(containerView.contentItem)
    }
    func cleanState(_ containerView: ContainerView) { }
}
extension EmptyDataSetView {
    func _configEmptyDataSetNoData(_ contentItem: ContentType) {
        if let contentProtocol = self as? EmptyDataSetContentProtocol {
            contentProtocol.configEmptyDataSetNoData(self)
        } else {
            contentItem.configEmptyDataSetNoData(self)
        }
    }
    func _configEmptyDataSetLoading(_ contentItem: ContentType) {
        if let contentProtocol = self as? EmptyDataSetContentProtocol {
            contentProtocol.configEmptyDataSetLoading(self)
        } else {
            contentItem.configEmptyDataSetLoading(self)
        }
    }
    func _configEmptyDataSetLoadFailed(_ contentItem: ContentType) {
        if let contentProtocol = self as? EmptyDataSetContentProtocol {
            contentProtocol.configEmptyDataSetLoadFailed(self)
        } else {
            contentItem.configEmptyDataSetLoadFailed(self)
        }
    }
}
extension EmptyDataSetContentView: EmptyDataSetContentProtocol {
    public func configEmptyDataSetNoData(_ containerView: ContainerView) {
        containerView.contentItem.addButtonIfNeed()
        containerView.contentItem.configLabel("无数据")
    }
    public func configEmptyDataSetLoadFailed(_ containerView: ContainerView) {
        containerView.contentItem.addButtonIfNeed()
        containerView.contentItem.configLabel("数据加载失败...")
    }
    public func configEmptyDataSetLoading(_ containerView: ContainerView) {
        containerView.contentItem.configActivityIndicator(.gray)
    }
}
