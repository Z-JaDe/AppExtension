//
//  CollectionCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/**
 自己实现复用cell，willAppear和didDisappear需要代理里面调用，UICollectionAdapter默认已经调用
 */
protocol CollectionCellConfigProtocol: CreateCollectionCellrotocol {
    func willAppear(in cell: UICollectionViewCell)
    func didDisappear(in cell: UICollectionViewCell)
}
