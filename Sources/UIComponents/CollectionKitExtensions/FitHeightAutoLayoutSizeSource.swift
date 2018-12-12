//
//  FitHeightAutoLayoutSizeSource.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/12/12.
//

import Foundation
import CollectionKit
open class FitHeightAutoLayoutSizeSource<Data, View: UIView>: SizeSource<Data> {
    private let dummyView: View
    private let dummyViewUpdater: ClosureViewUpdateFn<Data, View>
    private let horizontalFittingPriority: UILayoutPriority
    private let verticalFittingPriority: UILayoutPriority
    public init(dummyView: View.Type,
                horizontalFittingPriority: UILayoutPriority = .defaultHigh,
                verticalFittingPriority: UILayoutPriority = .defaultLow,
                viewUpdater: @escaping ClosureViewUpdateFn<Data, View>) {

        self.dummyView = View()
        self.dummyViewUpdater = viewUpdater
        self.horizontalFittingPriority = horizontalFittingPriority
        self.verticalFittingPriority = verticalFittingPriority
    }
    open override func size(at index: Int, data: Data, collectionSize: CGSize) -> CGSize {
        self.dummyViewUpdater(self.dummyView, data, index)

        let constraint = self.dummyView.widthAnchor.constraint(equalToConstant: collectionSize.width)
        constraint.priority = UILayoutPriority(rawValue: 999.1)
        constraint.isActive = true

        let _translates = self.dummyView.translatesAutoresizingMaskIntoConstraints
        self.dummyView.translatesAutoresizingMaskIntoConstraints = false

        let size = self.dummyView.systemLayoutSizeFitting(
            collectionSize,
            withHorizontalFittingPriority: self.horizontalFittingPriority,
            verticalFittingPriority: self.verticalFittingPriority)

        constraint.isActive = false
        self.dummyView.translatesAutoresizingMaskIntoConstraints = _translates
        return CGSize(width: collectionSize.width, height: size.height)
    }
}
