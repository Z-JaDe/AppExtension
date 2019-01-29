//
//  AssetGridModel.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/12/26.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
import Photos
import RxSwift

class AssetGridModel: CollectionItemModel {
    var image: BehaviorSubject<UIImage?> = BehaviorSubject(value: nil)
    var asset: PHAsset!

}
