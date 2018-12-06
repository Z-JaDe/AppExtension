//
//  CollectionCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public protocol CollectionCellConfigProtocol: CellConfigProtocol {
    func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func willAppear(in cell: UICollectionViewCell)
    func didDisappear(in cell: UICollectionViewCell)

    func createCell() -> CollectionItemCell
    func getCell() -> CollectionItemCell?
}
