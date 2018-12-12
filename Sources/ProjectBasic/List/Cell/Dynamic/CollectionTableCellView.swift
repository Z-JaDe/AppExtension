////
////  CollectionTableCellNode.swift
////  JDKit
////
////  Created by 茶古电子商务 on 2017/12/7.
////  Copyright © 2017年 Z_JaDe. All rights reserved.
////
//
//import UIKit
//
//open class CollectionTableCellNode: TableCellNode, TableViewDelegate {
//    public lazy var collectionNode: CollectionNode = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        let node = CollectionNode(collectionViewLayout: flowLayout)
//        return node
//    }()
//
//    open override func configInit() {
//        super.configInit()
//    }
//
//    open override func addChildNode() {
//        super.addChildNode()
//        self.addSubnode(collectionNode)
//    }
//
//    open override func didLoad() {
//        super.didLoad()
//
//        collectionNode.view.showsVerticalScrollIndicator = false
//        collectionNode.view.showsHorizontalScrollIndicator = false
//        collectionNode.view.alwaysBounceHorizontal = true
//
//        collectionNode.adapter.delegate = self
//
//    }
//    public func configCollectionNodeAutoHeight() {
//        if self.collectionNode.style.minHeight.value <= 0 {
//            self.collectionNode.style.minHeight = 1
//        }
//        self.collectionNode.view.rx.observe(CGSize.self, "contentSize").subscribeOnNext{[weak self] (contentSize) in
//            if let height = contentSize?.height, height > 0 {
//                self.collectionNode.style.height = ASDimension(height)
//                self.setNeedsLayout()
//            }
//            }.disposed(by: disposeBag)
//    }
//    override open func contentLayoutSpec(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        return self.collectionNode.wrapperSpec()
//    }
//
//    // MARK: - TableViewDelegate
//    open func didSelectItem(at indexPath: IndexPath) {
//
//    }
//}
//
