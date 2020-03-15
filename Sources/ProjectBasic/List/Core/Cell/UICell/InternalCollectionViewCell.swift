//
//  InternalCollectionViewCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
public protocol CollectionCellContentItem: UIView {
    var insets: UIEdgeInsets { get }

    func didDisappear()
}
extension CollectionCellContentItem {
    func getInternalCell() -> InternalCollectionViewCell? {
        self.superView(InternalCollectionViewCell.self)
    }
}
class InternalCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    var contentItem: CollectionCellContentItem? {
        willSet { newValue?.getInternalCell()?.contentItem = nil }
        didSet {
            oldValue?.removeFromSuperview()
            if let contentItem = self.contentItem {
                self.contentView.addSubview(contentItem)
            }
        }
    }
    func configInit() {

    }
    func setNeedsUpdateLayouts() {
        updateLayout()
    }
}
extension InternalCollectionViewCell {
    private func updateLayout() {
        guard let contentItem = self.contentItem else {
            return
        }
        contentItem.updateLayoutsMaker { (maker) in
            maker.edges.equalToSuperview().inset(contentItem.insets)
        }
    }
}
