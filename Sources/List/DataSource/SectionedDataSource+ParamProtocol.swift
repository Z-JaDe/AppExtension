//
//  DataSourceItemsParamProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/4.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension SectionedDataSource: DataSourceItemsParamProtocol {
    public func eachModel(_ closure: ((Any) -> Bool)) -> Bool {
        for sectionModel in self.dataController.sectionModels {
            let items: [Any] = sectionModel.items.map({ $0.realItem })
            let isContinue = items.eachModel(closure)
            if !isContinue {
                return false
            }
        }
        return true
    }
}
