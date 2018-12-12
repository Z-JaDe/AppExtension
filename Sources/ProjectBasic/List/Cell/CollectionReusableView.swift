//
//  CollectionReusableView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

class SNCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier: String = SNCollectionReusableView.classFullName
    var contentItem: CollectionReusableView?
}

class CollectionReusableView: ItemCell {

}
