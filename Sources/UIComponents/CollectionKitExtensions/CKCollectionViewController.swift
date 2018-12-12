//
//  CKCollectionViewController.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CollectionKit

public typealias CKCollectionView = CollectionKit.CollectionView
open class CKCollectionViewController: UIViewController {
    open override func loadView() {
        super.loadView()
        self.scrollView.frame = self.view.frame
        self.view = self.scrollView
    }
    public lazy private(set) var scrollView: CKCollectionView = CKCollectionView()
}
