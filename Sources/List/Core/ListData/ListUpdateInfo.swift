//
//  ListUpdateInfo.swift
//  Codable
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public class ListUpdateInfo<DataType> {
    public let data: DataType
    public var updateMode: ListUpdateMode
    public init(data: DataType) {
        self.data = data
        self.updateMode = .partial(animation: .automatic)
        self.completionHandle = {}
    }
    private init<T>(original: ListUpdateInfo<T>, data: DataType) {
        self.data = data
        self.updateMode = original.updateMode
        self.completionHandle = original.completionHandle
        original.completionHandle = {}
    }

    public func map<U>(_ transform: (DataType) throws -> U) rethrows -> ListUpdateInfo<U> {
        return ListUpdateInfo<U>(original: self, data: try transform(data))
    }
    /// ZJaDe: 局部(无)动画刷新 or 全局刷新
    public func configUpdateMode(_ updateMode: ListUpdateMode) -> Self {
        self.updateMode = updateMode
        return self
    }
    // MARK: -
    /// ZJaDe: 私有化，ListUpdateInfo传递时，只能有一个ListUpdateInfo持有completion
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
    public func updateInfo() -> ListUpdateInfo<ListData> {
        return ListUpdateInfo(data: self)
    }
}
