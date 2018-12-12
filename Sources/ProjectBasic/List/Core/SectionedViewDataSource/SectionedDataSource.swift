//
//  SectionedDataSource.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol SectionedDataSourceType {
    associatedtype S: SectionModelType
    associatedtype A: Updating
    typealias DataControllerType = DataController<S, A>
    var dataController: DataControllerType {get}
}

open class SectionedDataSource<S: SectionModelType, A: Updating>: NSObject, SectionedDataSourceType {
    public let dataController: DataController<S, A>
    public init(dataController: DataController<S, A>) {
        self.dataController = dataController
        super.init()
        self.configInit()
    }
    open func configInit() {

    }
    // MARK: -
    #if DEBUG
    // If data source has already been bound, then mutating it
    // afterwards isn't something desired.
    // This simulates immutability after binding
    internal var _dataSourceBound: Bool = false
    internal func ensureNotMutatedAfterBinding() {
        assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
    }
    #endif
    public typealias Element = ListUpdateInfo<[S]>
    func createUpdater(target: A.Target) -> Updater<A> {
        return Updater(A(target))
    }
    func rxChange(_ newValue: Element, _ updater: Updater<A>) {
        #if DEBUG
        self._dataSourceBound = true
        #endif
        self.dataController.update(newValue, updater)
    }
}