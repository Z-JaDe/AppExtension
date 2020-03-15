//
//  SectionedDataSource.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public protocol SectionedDataSourceType: class {
    associatedtype S: SectionModelType
    typealias DataControllerType = DataController<S>
    var dataController: DataControllerType {get}
    init()
    init(dataController: DataController<S>)

    var didMoveItem: ((S.Item, S.Item) -> Void)? { get set }
}

open class SectionedDataSource<S: SectionModelType>: NSObject, SectionedDataSourceType {
    public let dataController: DataController<S>
    public required init(dataController: DataController<S>) {
        self.dataController = dataController
        super.init()
        configInit()
    }
    public required convenience override init() {
        self.init(dataController: DataController())
    }
    open func configInit() {

    }
    // MARK: -
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    public var _dataSourceBound: Bool = false
    internal func ensureNotMutatedAfterBinding() {
        assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
    #endif
    /// ZJaDe: 手动 移动编辑后调用该闭包
    public var didMoveItem: ((S.Item, S.Item) -> Void)?

    public typealias Element = [S]
}
