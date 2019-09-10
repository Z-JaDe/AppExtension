//
//  DataController+Update.swift
//  Codable
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

public enum ListUpdateMode {
    case everything
    case partial(animation: UITableView.RowAnimation)
}

extension DataController {
    func updateNewData(_ newData: ListDataInfo<[S]>, _ updater: Updater) {
        updater.becomeUpdating()
        let stagedChangeset = StagedChangeset<[S]>(source: self.sectionModels, target: newData.data)
        updater.updateWithMode(
            using: stagedChangeset,
            updateMode: newData.updateMode,
            interrupt: {$0.data.count > 100},
            setData: setSections,
            completion: { _ in
                newData.performCompletion()
                newData.infoRelease()
                self.reloadDataCompletion.call()
        })
    }
}
extension Updater {
    /// ZJaDe: 刷新或者更新列表, 根据updateMode判断
    fileprivate func updateWithMode<C>(
        using stagedChangeset: StagedChangeset<C>,
        updateMode: ListUpdateMode,
        interrupt: ((Changeset<C>) -> Bool)?,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        var updateMode = updateMode
        if updating.isInHierarchy == false {
            updateMode = .everything
        } else if self.dataSet == false {
            self.dataSet = true
            updateMode = .everything
        }
        switch updateMode {
        case .everything:
            if let data = stagedChangeset.last?.data {
                reload(data: data, setData: setData, completion: completion)
            } else {
                completion(true)
            }
        case .partial(animation: let animation):
            update(using: stagedChangeset, interrupt: interrupt, animation: animation, setData: setData, completion: completion)
        }
    }
}
