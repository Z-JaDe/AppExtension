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
    public var didSelectItem: ((ProviderType.TapContext) -> Void)? {
        get { self.provider.tapHandler }
        set { self.provider.tapHandler = newValue }
    }
    /// ZJaDe: 数据绑定
    open override var viewUpdater: ViewUpdaterFn {
        didSet {
            self.provider.viewSource = ClosureViewSource(viewUpdater: viewUpdater)
            self.provider.sizeSource = CKCycleView.createSizeSource(viewUpdater: viewUpdater)
        }
    }
    /// ZJaDe:
    let dataSource: CycleDataSource<Data> = CycleDataSource(data: [])
    public typealias ProviderType = BasicProvider<Data, View>
    private let provider: ProviderType
    public override init(viewUpdater: @escaping ViewUpdaterFn) {
        self.provider = CKCycleView.createProvider(dataSource: dataSource, viewUpdater: viewUpdater)
        super.init(viewUpdater: viewUpdater)
    }
    public required init?(coder aDecoder: NSCoder) {
        self.provider = CKCycleView.createProvider(dataSource: dataSource, viewUpdater: { _, _, _ in })
        super.init(coder: aDecoder)
    }
    open override func configInit() {
        super.configInit()
        self.addSubview(self.scrollView)
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.provider = self.provider
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
    }

    open override func configData(_ dataArray: [Data]) {
        super.configData(dataArray)
        if let data = dataArray.first {
            self.calculateHeight = self.provider.sizeSource.size(at: 0, data: data, collectionSize: self.bounds.size).height
        }
        self.dataSource.data = dataArray
        self.scrollView.reloadData()
        resetCellsOrigin()
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
        super.scrollViewWillBeginDragging(scrollView)
        resetCellsOrigin()
    }
}
extension CKCycleView {
    private static func createProvider(dataSource: CycleDataSource<Data>, viewUpdater: @escaping ViewUpdaterFn) -> ProviderType {
        ProviderType(
            dataSource: dataSource,
            viewSource: ClosureViewSource(viewUpdater: viewUpdater),
            sizeSource: self.createSizeSource(viewUpdater: viewUpdater),
            layout: RowLayout()
        )
    }
    private static func createSizeSource(viewUpdater: @escaping ViewUpdaterFn) -> AutoLayoutSizeSource<Data, View> {
        AutoLayoutSizeSource(dummyView: View.self, horizontalFittingPriority: .init(999.1), viewUpdater: viewUpdater)
    }
}
extension CKCycleView {
    private func resetCellsOrigin() {
        resetCellsOrigin(repeatCount: self.dataSource.repeatCount)
    }
}
extension CKCollectionView: OneWayScrollable {
    public var scrollDirection: ScrollDirection {
        .horizontal
    }
}
