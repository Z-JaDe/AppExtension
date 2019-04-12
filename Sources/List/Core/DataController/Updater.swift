//
//  Updater.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import DifferenceKit

public enum ListUpdateMode {
    case everything
    case partial(animation: UITableView.RowAnimation)
}
public final class Updater {
    enum State {
        case idle
        case updating
    }
    /// ZJaDe: 暂时只做记录，由外部控制刷新，若是手动调用的更新需要检查下isUpdating
    private var state: State = .idle {
        willSet { assertMainThread() }
    }
    public func becomeUpdating() {
        self.state = .updating
    }
    public var isUpdating: Bool {
        return self.state == .updating
    }

    private let updating: Updating
    init(_ updating: Updating) {
        self.updating = updating
    }
    /// ZJaDe: 刷新或者更新列表, 根据updateMode判断
    func update<C>(
        using stagedChangeset: StagedChangeset<C>,
        updateMode: ListUpdateMode,
        interrupt: ((Changeset<C>) -> Bool)?,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        var updateMode = updateMode
        if updating.isInHierarchy == false {
            updateMode = .everything
        }
        switch updateMode {
        case .everything:
            if let data = stagedChangeset.last?.data {
                reload(
                    data: data,
                    setData: setData,
                    completion: completion
                )
            } else {
                completion(true)
            }
        case .partial(animation: let animation):
            update(
                using: stagedChangeset,
                interrupt: interrupt,
                animation: animation,
                setData: setData,
                completion: completion
            )
        }
    }

    /// ZJaDe: 更新列表
    func update<C>(
        using stagedChangeset: StagedChangeset<C>,
        interrupt: ((Changeset<C>) -> Bool)?,
        animation: UITableView.RowAnimation,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        for changeset in stagedChangeset {
            if let interrupt = interrupt, interrupt(changeset), let data = stagedChangeset.last?.data {
                self.reload(data: data, setData: setData, completion: completion)
                return
            }
        }
        self.state = .updating
        self.updating.performBatch(animated: animation != .none, updates: {
            for changeset in stagedChangeset {
                self.update(changeset: changeset, interrupt: interrupt, animation: animation, setData: setData)
            }
        }, completion: { (result) in
            self.state = .idle
            completion(result)
        })
    }
    /// ZJaDe: 刷新列表
    func reload<C>(
        data: C,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        self.state = .updating
        setData(data)
        updating.reload {
            self.state = .idle
            completion(true)
        }
    }
}

extension Updater {
    private func update<C>(
        changeset: Changeset<C>,
        interrupt: ((Changeset<C>) -> Bool)?,
        animation: UITableView.RowAnimation,
        setData: (C) -> Void
        ) {
        setData(changeset.data)
        if !changeset.sectionDeleted.isEmpty {
            updating.deleteSections(IndexSet(changeset.sectionDeleted), with: animation)
        }
        if !changeset.sectionInserted.isEmpty {
            updating.insertSections(IndexSet(changeset.sectionInserted), with: animation)
        }
        if !changeset.sectionUpdated.isEmpty {
            updating.reloadSections(IndexSet(changeset.sectionUpdated), with: animation)
        }
        for (source, target) in changeset.sectionMoved {
            updating.moveSection(source, toSection: target)
        }
        if !changeset.elementDeleted.isEmpty {
            updating.deleteItems(at: changeset.elementDeleted.map(mapIndexPath), with: animation)
        }
        if !changeset.elementInserted.isEmpty {
            updating.insertItems(at: changeset.elementInserted.map(mapIndexPath), with: animation)
        }
        if !changeset.elementUpdated.isEmpty {
            updating.reloadItems(at: changeset.elementUpdated.map(mapIndexPath), with: animation)
        }
        for (source, target) in changeset.elementMoved {
            updating.moveItem(at: mapIndexPath(source), to: mapIndexPath(target))
        }
    }
    private func mapIndexPath(_ indexPath: ElementPath) -> IndexPath {
        return IndexPath(row: indexPath.element, section: indexPath.section)
    }
}

extension Updater {
    var isInHierarchy: Bool {
        return updating.isInHierarchy
    }
    public func performBatch(animated: Bool, updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
        Async.main {
            self.state = .updating
            self.updating.performBatch(animated: animated, updates: updates, completion: { (result) in
                completion(result)
                self.state = .idle
            })
        }
    }
}
