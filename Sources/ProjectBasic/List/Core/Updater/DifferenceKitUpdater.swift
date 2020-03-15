////
////  DifferenceKitUpdater.swift
////  ProjectBasic
////
////  Created by 郑军铎 on 2020/3/16.
////  Copyright © 2020 ZJaDe. All rights reserved.
////
//
//import Foundation
//import DifferenceKit
//
//class DifferenceKitUpdater: Updater {
//
//    //    func updateNewData(_ newData: [S], _ updater: Updater) {
//    //        updater.update(
//    //            using: StagedChangeset<[S]>(source: self.sectionModels, target: newData.data),
//    //            dataSetter: Updater.DataSetter(updating: newData.updating, interrupt: {$0.data.count > 100}, setData: setSections, completion: { (_) in
//    //                newData._performCompletion()
//    //                newData._infoRelease()
//    //                self.reloadDataCompletion.call()
//    //            })
//    //        )
//    //    }
//    public struct DataSetter<C: Swift.Collection> {
//        var updating: Updating
//        let interrupt: ((Changeset<C>) -> Bool)?
//        let setData: (C) -> Void
//        let completion: (Bool) -> Void
//
//        public init(updating: Updating, interrupt: ((Changeset<C>) -> Bool)?, setData: @escaping (C) -> Void, completion: @escaping (Bool) -> Void) {
//            self.updating = updating
//            self.interrupt = interrupt
//            self.setData = setData
//            self.completion = completion
//        }
//
//        func isNeedReload(using stagedChangeset: StagedChangeset<C>) -> Bool {
//            guard let interrupt = interrupt else {
//                return false
//            }
//            return stagedChangeset.contains(where: {interrupt($0)})
//        }
//    }
//    /// ZJaDe: 根据updateMode判断局部更新还是直接刷新
//    public func update<C>(using stagedChangeset: @escaping @autoclosure () -> StagedChangeset<C>, dataSetter: DataSetter<C>) {
//        dataSafeExecute { (doneClosure) in
//            var dataSetter = dataSetter
//            if dataSetter.updating.isInHierarchy == false {
//                dataSetter.updating.updateMode = .everything
//            } else if self.dataSet == false {
//                self.dataSet = true
//                dataSetter.updating.updateMode = .everything
//            }
//            switch dataSetter.updating.updateMode {
//            case .everything:
//                dataSetter._reload(data: stagedChangeset().last?.data, done: doneClosure)
//            case .partial:
//                dataSetter._partialUpdate(using: stagedChangeset(), done: doneClosure)
//            }
//        }
//    }
//    /// ZJaDe: 刷新列表
//    public func reload<C>(data: C, dataSetter: DataSetter<C>) {
//        dataSafeExecute { (doneClosure) in
//            dataSetter._reload(data: data, done: doneClosure)
//        }
//    }
//    /// ZJaDe: 更新列表
//    public func partialUpdate<C>(using stagedChangeset: @escaping @autoclosure () -> StagedChangeset<C>, dataSetter: DataSetter<C>) {
//        dataSafeExecute { (doneClosure) in
//            dataSetter._partialUpdate(using: stagedChangeset(), done: doneClosure)
//        }
//    }
//    
//}
//
//extension DifferenceKitUpdater.DataSetter {
//    @inline(__always)
//    public func _reload(data: C?, done: @escaping () -> Void) {
//        if let data = data {
//            setData(data)
//            updating.reload {
//                self.completion(true)
//                done()
//            }
//        } else {
//            self.completion(true)
//            done()
//        }
//    }
//    @inline(__always)
//    public func _partialUpdate(using stagedChangeset: StagedChangeset<C>, done: @escaping () -> Void) {
//        if isNeedReload(using: stagedChangeset) {
//            _reload(data: stagedChangeset.last?.data, done: done)
//        } else {
//            updating.performBatch(updates: {
//                stagedChangeset.forEach({self._update(changeset: $0)})
//            }, completion: { (result) in
//                self.completion(result)
//                done()
//            })
//        }
//    }
//    @inline(__always)
//    private func _update(changeset: Changeset<C>) {
//        setData(changeset.data)
//        if !changeset.sectionDeleted.isEmpty {
//            updating.deleteSections(IndexSet(changeset.sectionDeleted))
//        }
//        if !changeset.sectionInserted.isEmpty {
//            updating.insertSections(IndexSet(changeset.sectionInserted))
//        }
//        if !changeset.sectionUpdated.isEmpty {
//            updating.reloadSections(IndexSet(changeset.sectionUpdated))
//        }
//        for (source, target) in changeset.sectionMoved {
//            updating.moveSection(source, toSection: target)
//        }
//        if !changeset.elementDeleted.isEmpty {
//            updating.deleteItems(at: changeset.elementDeleted.map(map))
//        }
//        if !changeset.elementInserted.isEmpty {
//            updating.insertItems(at: changeset.elementInserted.map(map))
//        }
//        if !changeset.elementUpdated.isEmpty {
//            updating.reloadItems(at: changeset.elementUpdated.map(map))
//        }
//        for (source, target) in changeset.elementMoved {
//            updating.moveItem(at: map(indexPath: source), to: map(indexPath: target))
//        }
//    }
//    @inline(__always)
//    private func map(indexPath: ElementPath) -> IndexPath {
//        IndexPath(row: indexPath.element, section: indexPath.section)
//    }
//}
