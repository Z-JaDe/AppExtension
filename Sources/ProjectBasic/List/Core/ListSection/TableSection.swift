//
//  TableSection.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/10/19.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
extension Font.List {
    public static var sectionHeader: UIFont = Font.h4
    public static var sectionFooter: UIFont = Font.h4
}
extension Color.List {
    public static var sectionHeader: UIColor = Color.gray
    public static var sectionFooter: UIColor = Color.gray
}
open class TableSection: ListSection {

    open lazy var headerView: TableViewHeaderView = TableViewHeaderView()
    open lazy var footerView: TableViewFooterView = TableViewFooterView()

    @discardableResult
    open func changeHeader(height: CGFloat) -> Self {
        self.headerView.defaultHeight = height
        return self
    }
    @discardableResult
    open func changeFooter(height: CGFloat) -> Self {
        self.footerView.defaultHeight = height
        return self
    }

    @discardableResult
    open func changeHeader(inset: UIEdgeInsets) -> Self {
        headerView.inset = inset
        return self
    }
    @discardableResult
    open func changeFooter(inset: UIEdgeInsets) -> Self {
        footerView.inset = inset
        return self
    }

    @discardableResult
    open func changeHeader(title: String, font: UIFont = Font.List.sectionHeader, color: UIColor = Color.List.sectionHeader) -> Self {
        headerView.changeTitle(title, font: font, color: color)
        return self
    }
    @discardableResult
    open func changeFooter(title: String, font: UIFont = Font.List.sectionFooter, color: UIColor = Color.List.sectionFooter) -> Self {
        footerView.changeTitle(title, font: font, color: color)
        return self
    }

    @discardableResult
    open func changeHeader(attrText: NSAttributedString) -> Self {
        headerView.changeAttrTitle(attrText)
        return self
    }
    @discardableResult
    open func changeFooter(attrText: NSAttributedString) -> Self {
        footerView.changeAttrTitle(attrText)
        return self
    }
}
