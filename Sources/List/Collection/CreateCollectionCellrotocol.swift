//
//  CreateCollectionCellrotocol.swift
//  AppExtension
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol CreateCollectionCellrotocol {
    func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}
