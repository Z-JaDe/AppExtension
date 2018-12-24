//
//  WindowScheduler.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/24.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class WindowScheduler<WindowState: Hashable>: Scheduler {
    public private(set) var windowStateArr: [WindowState] = []
    public var windowItemData: [WindowState: WindowRootItem] = [:]
    private var coordinator: AbstractWindowCoordinator!
    func start(_ coordinator: AbstractWindowCoordinator) {
        self.coordinator = coordinator
    }

    /// ZJaDe: 调用此方法能更新windowStateArr最新状态 需重写该方法
    open func updateState() {
        jdAbstractMethod()
    }
    /// ZJaDe: 根据state初始化创建WindowRootItem 需重写该方法
    open func inializers(state: WindowState) {
        jdAbstractMethod()
    }
    /// ZJaDe: 添加state，updateState方法里面能用到
    open func add(state: WindowState) {
        windowStateArr.append(state)
        if windowItemData[state] == nil {
            inializers(state: state)
        }
    }
    /// ZJaDe: 移除state，可以重写，无须手动调用，可以使用end(state:)
    open func remove(state: WindowState) {
        // ZJaDe: state显示结束后移除
        windowStateArr.remove(state)
    }
    /// ZJaDe: 结束state，windowItem结束后手动调用
    public func end(state: WindowState) {
        let oldLastState = windowStateArr.last
        remove(state: state)
        // ZJaDe: 加载windowState栈里面最上面的state
        loadLastItem(oldLastState)
    }
}
extension WindowScheduler {
    private func cleanRedundantItemData() {
        self.windowItemData = self.windowItemData.filter({windowStateArr.contains($0.key)})
    }
    public func loadLastItem(_ oldLastState: WindowState?) {
        cleanRedundantItemData()
        guard oldLastState != windowStateArr.last else { return }
        if let state = windowStateArr.last, let item = windowItemData[state] {
            coordinator.load(item)
        } else {
            coordinator.load(nil)
        }
    }
}
