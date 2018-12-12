//
//  CKCycleView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CollectionKit
open class CKCycleView<Data, View: UIView>: CustomView, UIScrollViewDelegate {
    /// ZJaDe: 点击item
    public var tapHandler: ((BasicProvider<Data,View>.TapContext) -> Void)?
    /// ZJaDe: 配置model
    public var viewUpdater: ((View, Data, Int) -> Void) = {_,_,_ in} {
        didSet {
            self.provider.viewSource = ClosureViewSource(viewUpdater: viewUpdater)
            self.provider.sizeSource = FitHeightAutoLayoutSizeSource(dummyView: View.self, viewUpdater: viewUpdater)
        }
    }

    public lazy private(set) var scrollView: CKCollectionView = CKCollectionView()
    lazy var dataSource: CycleDataSource<Data> = CycleDataSource(data: [])
    private lazy var provider = BasicProvider(dataSource: dataSource,
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
        self.provider.tapHandler = self.tapHandler
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
    }

    private var calculateHeight: CGFloat? {
        didSet { invalidateIntrinsicContentSize() }
    }
    public func configData(_ dataArray: [Data]) {
        if let data = dataArray.first {
            self.calculateHeight = FitHeightAutoLayoutSizeSource(dummyView: View.self, viewUpdater: viewUpdater).size(at: 0, data: data, collectionSize: self.bounds.size).height
        }
        self.dataSource.data = dataArray
        self.scrollView.reloadData()
        resetItemViewsLocation()
    }

    open override var intrinsicContentSize: CGSize {
        if let height = calculateHeight {
            return CGSize(width: max(size.width, 1), height: height)
        } else {
            return CGSize(width: max(size.width, 1), height: max(size.height, 1))
        }
    }
    // MARK: -
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetItemViewsLocation()
    }
}
extension CKCycleView: SingleFormProtocol {
    public var totalCount: Int {
        return self.dataSource.data.count
    }
    public var currentIndex: Int {
        get {return realProgress(offSet: self.scrollView.viewHeadOffset(), length: self.scrollView.length).toInt}
        set {
            self.scrollView.scrollTo(offSet: newValue.toCGFloat * self.scrollView.length)
            resetItemViewsLocation()
        }
    }
    private func resetItemViewsLocation() {
        resetItemViewsLocation(repeatCount: self.dataSource.repeatCount, in: scrollView)
    }
}
extension CKCollectionView: OneWayScrollProtocol {
    public var scrollDirection: ScrollDirection {
        return .horizontal
    }
}
