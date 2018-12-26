//
//  CKCycleView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CollectionKit
open class CKCycleView<View: UIView, Data>: PageItemsView<View, Data, CKCollectionView> {
    /// ZJaDe: 点击item
    public var didSelectItem: ((BasicProvider<Data, View>.TapContext) -> Void)?
    /// ZJaDe: 配置model
    open override var viewUpdater: ((View, Data, Int) -> Void) {
        get {return super.viewUpdater}
        set {
            super.viewUpdater = newValue
            self.provider.viewSource = ClosureViewSource(viewUpdater: viewUpdater)
            self.provider.sizeSource = FitHeightAutoLayoutSizeSource(dummyView: View.self, viewUpdater: viewUpdater)
        }
    }

    lazy var dataSource: CycleDataSource<Data> = CycleDataSource(data: [])
    private lazy var provider = BasicProvider(
        dataSource: dataSource,
        viewSource: ClosureViewSource(viewUpdater: viewUpdater),
        sizeSource: FitHeightAutoLayoutSizeSource(dummyView: View.self, viewUpdater: viewUpdater),
        layout: RowLayout()
    )

    open override func configInit() {
        super.configInit()
        self.addSubview(self.scrollView)
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.provider = self.provider
        self.provider.tapHandler = self.didSelectItem
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
    }

    open override func configData(_ dataArray: [Data]) {
        super.configData(dataArray)
        if let data = dataArray.first {
            self.calculateHeight = FitHeightAutoLayoutSizeSource(dummyView: View.self, viewUpdater: viewUpdater).size(at: 0, data: data, collectionSize: self.bounds.size).height
        }
        self.dataSource.data = dataArray
        self.scrollView.reloadData()
        resetItemViewsLocation()
    }

    private var calculateHeight: CGFloat? {
        didSet { invalidateIntrinsicContentSize() }
    }
    open override var intrinsicContentSize: CGSize {
        if let height = calculateHeight {
            return CGSize(width: max(size.width, 1), height: height)
        } else {
            return CGSize(width: max(size.width, 1), height: max(size.height, 1))
        }
    }
    // MARK: -
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetItemViewsLocation()
    }
}
extension CKCycleView {
    private func resetItemViewsLocation() {
        resetItemViewsLocation(repeatCount: self.dataSource.repeatCount)
    }
}
extension CKCollectionView: OneWayScrollProtocol {
    public var scrollDirection: ScrollDirection {
        return .horizontal
    }
}
