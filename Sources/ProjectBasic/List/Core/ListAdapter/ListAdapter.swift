//
//  ListAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

//下面两个协议，是为了内部 检测 是否实现了对应的协议。AdapterItemType后面都是可选协议，实现了就能用，不实现也不报错
public protocol _AdapterItemType: AdapterItemType & HiddenStateDesignable & EnabledStateDesignable {} //CanSelectedStateDesignable
public protocol _AdapterSectionType: AdapterSectionType {}

open class ListAdapter<DataSource: SectionedDataSourceType>
where DataSource.S.Item: AdapterItemType, DataSource.S.Section: AdapterSectionType {
    public typealias DataSource = DataSource
    public typealias Section = DataSource.S.Section
    public typealias Item = DataSource.S.Item
    public init() {
        self.configInit()
    }
    public func configInit() {

    }
    deinit {
        logDebug("\(type(of: self))->\(self)注销")
    }
    /// ZJaDe: 是否自动改回未选中，子类实现相关逻辑
    public var autoDeselectRow = true
    /// ZJaDe: 缓存池
    let bufferPool: BufferPool = BufferPool()

    // MARK: -
    open var isEnabled: Bool? {
        didSet {
            if let isEnabled = self.isEnabled, isEnabled != oldValue {
                (self as? EnabledStateDesignable)?.updateEnabledState(isEnabled)
            }
        }
    }
}
extension ListAdapter: DisposeBagProtocol {}
