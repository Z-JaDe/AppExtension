//
//  CycleDataSource.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CollectionKit
open class CycleDataSource<Data>: DataSource<Data> {
    open var data: [Data] {
        didSet {
            setNeedsReload()
        }
    }
    open var identifierMapper: (Int, Data) -> String {
        didSet {
            setNeedsReload()
        }
    }
    let repeatCount: Int = 10

    public init(data: [Data] = [], identifierMapper: @escaping (Int, Data) -> String = { index, _ in "\(index)" }) {
        self.data = data
        self.identifierMapper = identifierMapper
    }

    open override var numberOfItems: Int {
        return data.count * repeatCount
    }
    open override func identifier(at: Int) -> String {
        return identifierMapper(at, data(at: at))
    }
    open override func data(at: Int) -> Data {
        return data[at % data.count]
    }
}
