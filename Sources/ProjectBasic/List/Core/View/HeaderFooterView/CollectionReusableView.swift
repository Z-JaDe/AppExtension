//
//  CollectionReusableView.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

class InternalCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier: String = InternalCollectionReusableView.classFullName
    var contentItem: CollectionReusableView?
}

class CollectionReusableView: ItemCell {

}
