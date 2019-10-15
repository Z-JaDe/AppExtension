//
//  SearchBar.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/17.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

open class SearchBar: UISearchBar, WritableDefaultHeightProtocol {
    public var defaultHeight: CGFloat = 44 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    open override var intrinsicContentSize: CGSize {
        var resultSize = super.intrinsicContentSize
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        var resultSize = super.systemLayoutSizeFitting(targetSize)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize = super.sizeThatFits(size)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = self.defaultHeight
    }
}
open class SearchController: UISearchController {
    lazy var _searchBar: SearchBar = SearchBar()
    open override var searchBar: UISearchBar {
        _searchBar
    }
}
