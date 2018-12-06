//
//  TableSection.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/10/19.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
open class TableSection: ListSection {

    open lazy var headerView: TableViewHeaderView = {
        let view = TableViewHeaderView()
        return view
    }()
    open lazy var footerView: TableViewFooterView = {
        let view = TableViewFooterView()
        return view
    }()

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
    open func changeHeader(title: String, font: UIFont = Font.h4_big, color: UIColor = Color.gray) -> Self {
        headerView.changeTitle(title, font: font, color: color)
        return self
    }
    @discardableResult
    open func changeFooter(title: String, font: UIFont = Font.h4_big, color: UIColor = Color.gray) -> Self {
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
