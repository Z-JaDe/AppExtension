//
//  DataController+Update.swift
//  Codable
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

extension DataController {
    func update(_ newData: ListUpdateInfo<[S]>, _ updater: Updater) {
        let stagedChangeset = StagedChangeset<[S]>(source: self.sectionModels, target: newData.data)
        let updateMode: ListUpdateMode
        if self.dataSet == false {
            self.dataSet = true
            updateMode = .everything
        } else {
            updateMode = newData.updateMode
        }
        updater.update(
            using: stagedChangeset,
            updateMode: updateMode,
            interrupt: {$0.data.count > 100},
            setData: {self.setSections($0)},
            completion: { _ in
                newData.performCompletion()
                newData.infoRelease()
                self.reloadDataCompletion.onNext(())
        })
    }
}
