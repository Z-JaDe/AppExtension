//
//  Data+Updater.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2020/3/16.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation
extension SectionedDataSource {
    func dataChange(_ newValue: Element, _ updater: Updater, _ updating: Updating, _ completion: (() -> Void)?) {
        #if DEBUG
        self._dataSourceBound = true
        #endif
        dataController.dataChange(newValue, updater, updating, completion)
    }
}
extension DataController {
    func dataChange(_ newValue: [S], _ updater: Updater, _ updating: Updating, _ completion: (() -> Void)?) {
        let dataSetter = Updater.DataSetter<[S]>(updating: updating, setData: setSections, completion: { [weak self] (_) in
            completion?()
            self?.reloadDataCompletion.call()
        })
        updater.update(source: self.sectionModels, target: newValue, dataSetter: dataSetter)
    }
}
