//
//  DataSourceItemsParamProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/4.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension CollectionViewDataSource: DataSourceItemsParamProtocol {
    public func eachModel(_ closure: ((Any) -> Bool)) -> Bool {
        for sectionModel in self.dataController.sectionModels {
            let isContinue = sectionModel.items.eachModel(closure)
            if !isContinue {
                return false
            }
        }
        return true
    }
}
extension TableViewDataSource: DataSourceItemsParamProtocol {
    public func eachModel(_ closure: ((Any) -> Bool)) -> Bool {
        for sectionModel in self.dataController.sectionModels {
            var items: [Any] = []
            for item in sectionModel.items {
                if let item = item as? TableAdapterItemCompatible {
                    switch item {
                    case .cell(let cell):
                        items.append(cell)
                    case .model(let model):
                        items.append(model)
                    }
                } else {
                    items.append(item)
                }
            }
            let isContinue = items.eachModel(closure)
            if !isContinue {
                return false
            }
        }
        return true
    }
}
