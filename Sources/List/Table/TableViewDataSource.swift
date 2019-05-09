//
//  SectionedDataSource.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit

open class TableViewDataSource<S: SectionModelType>: SectionedDataSource<S>, UITableViewDataSource {
    public typealias ConfigureCell = (TableViewDataSource<S>, UITableView, IndexPath, S.Item) -> UITableViewCell
    public typealias TitleForHeaderInSection = (TableViewDataSource<S>, Int) -> String?
    public typealias TitleForFooterInSection = (TableViewDataSource<S>, Int) -> String?
    public typealias CanEditRowAtIndexPath = (TableViewDataSource<S>, IndexPath) -> Bool
    public typealias CanMoveRowAtIndexPath = (TableViewDataSource<S>, IndexPath) -> Bool

    open var configureCell: ConfigureCell = { _, _, _, _ in fatalError("You must set cellFactory") } {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var titleForHeaderInSection: TitleForHeaderInSection = { _, _ in nil } {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var titleForFooterInSection: TitleForFooterInSection = { _, _ in nil } {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var canEditRowAtIndexPath: CanEditRowAtIndexPath = { _, _ in false } {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath = { _, _ in false } {
        didSet {
            #if DEBUG
                ensureNotMutatedAfterBinding()
            #endif
        }
    }

    #if os(iOS)
    public typealias SectionIndexTitles = (TableViewDataSource<S>) -> [String]?
    public typealias SectionForSectionIndexTitle = (TableViewDataSource<S>, _ title: String, _ index: Int) -> Int
    open var sectionIndexTitles: SectionIndexTitles = { _ in nil } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var sectionForSectionIndexTitle: SectionForSectionIndexTitle = { _, _, index in index } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    #endif

    // UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataController._data.count
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataController.sectionIndexCanBound(section) else { return 0 }
        return dataController._data[section].items.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        precondition(dataController.indexPathCanBound(indexPath))
        return configureCell(self, tableView, indexPath, dataController[indexPath])
    }

    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(self, section)
    }

    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection(self, section)
    }

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRowAtIndexPath(self, indexPath)
    }

    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRowAtIndexPath(self, indexPath)
    }

    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = dataController[sourceIndexPath]
        let destination = dataController[destinationIndexPath]
        dataController.move(sourceIndexPath, target: destinationIndexPath)
        self.didMoveItem?(self, source, destination)
    }

    #if os(iOS)
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles(self)
    }

    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle(self, title, index)
    }
    #endif
}

#endif
