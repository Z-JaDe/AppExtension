//
//  DifferenceKitUpdater.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2020/3/16.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

public struct AnyDiffable<V: Hashable>: Hashable, Differentiable {
    let value: V
    init(_ value: V) {
        self.value = value
    }
}

public class DifferenceKitUpdater: Updater {
    public var updateMode: UpdateMode = .partial
    public override func update<Element: Hashable>(source: [Element], target: [Element], dataSetter: Updater.DataSetter<Element>) {
        dataSafeExecute { (doneClosure) in
            var updateMode = self.tempUpdateMode ?? self.updateMode
            if dataSetter.updating.isInHierarchy == false {
                updateMode = .everything
            } else if self.dataSet == false {
                self.dataSet = true
                updateMode = .everything
            }
            switch updateMode {
            case .everything:
                dataSetter._reload(data: target, done: doneClosure)
            case .partial:
                let stagedChangeset = StagedChangeset(source: source.map(AnyDiffable.init), target: target.map(AnyDiffable.init))
                if stagedChangeset.contains(where: {$0.data.count > 100}) {
                    dataSetter._reload(data: target, done: doneClosure)
                } else {
                    dataSetter._partialUpdate(using: stagedChangeset, done: doneClosure)
                }
            }
        }
    }
}

extension DifferenceKitUpdater.DataSetter where Element: Hashable {
    @inline(__always)
    public func _partialUpdate(using stagedChangeset: StagedChangeset<[AnyDiffable<Element>]>, done: @escaping () -> Void) {
        updating.performBatch(updates: {
            stagedChangeset.forEach({self._update(changeset: $0)})
        }, completion: { (result) in
            self.completion(result)
            done()
        })
    }
    @inline(__always)
    private func _update(changeset: Changeset<[AnyDiffable<Element>]>) {
        setData(changeset.data.map {$0.value})
        if !changeset.sectionDeleted.isEmpty {
            updating.deleteSections(IndexSet(changeset.sectionDeleted))
        }
        if !changeset.sectionInserted.isEmpty {
            updating.insertSections(IndexSet(changeset.sectionInserted))
        }
        if !changeset.sectionUpdated.isEmpty {
            updating.reloadSections(IndexSet(changeset.sectionUpdated))
        }
        for (source, target) in changeset.sectionMoved {
            updating.moveSection(source, toSection: target)
        }
        if !changeset.elementDeleted.isEmpty {
            updating.deleteItems(at: changeset.elementDeleted.map(map))
        }
        if !changeset.elementInserted.isEmpty {
            updating.insertItems(at: changeset.elementInserted.map(map))
        }
        if !changeset.elementUpdated.isEmpty {
            updating.reloadItems(at: changeset.elementUpdated.map(map))
        }
        for (source, target) in changeset.elementMoved {
            updating.moveItem(at: map(indexPath: source), to: map(indexPath: target))
        }
    }
    @inline(__always)
    private func map(indexPath: ElementPath) -> IndexPath {
        IndexPath(row: indexPath.element, section: indexPath.section)
    }
}
