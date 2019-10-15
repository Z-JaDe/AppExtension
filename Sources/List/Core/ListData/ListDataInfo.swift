//
//  ListDataInfo.swift
//  Codable
//
//  Created by ZJaDe on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public class ListDataInfo<DataType> {
    public let data: DataType
    public var updateMode: ListUpdateMode
    public init(data: DataType) {
        self.data = data
        self.updateMode = .partial(animation: .automatic)
        self.completionHandle = {}
    }
    private init<T>(original: ListDataInfo<T>, data: DataType) {
        self.data = data
        self.updateMode = original.updateMode
        self.completionHandle = original.completionHandle
        original.completionHandle = {}
    }

    public func map<U>(_ transform: (DataType) throws -> U) rethrows -> ListDataInfo<U> {
        ListDataInfo<U>(original: self, data: try transform(data))
    }
    /// ZJaDe: 局部(无)动画刷新 or 全局刷新
    public func configUpdateMode(_ updateMode: ListUpdateMode) -> Self {
        self.updateMode = updateMode
        return self
    }
    // MARK: -
    /// ZJaDe: 私有化，ListDataInfo传递时，只能有一个ListDataInfo持有completion
    private var completionHandle: () -> Void
    /// ZJaDe: 刷新完成后 会自动释放闭包
    public func completion(_ closure: @escaping () -> Void) -> Self {
        self.completionHandle = closure
        return self
    }
    internal func performCompletion() {
        self.completionHandle()
    }
    // MARK: - 
    internal func infoRelease() {
        self.completionHandle = {}
    }
}
extension ListData {
    public func updateInfo() -> ListDataInfo<ListData> {
        ListDataInfo(data: self)
    }
}
