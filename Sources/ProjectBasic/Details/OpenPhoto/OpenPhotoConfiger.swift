//
//  OpenPhotoConfiger.swift
//  JDKit
//
//  Created by ZJaDe on 2017/11/14.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift

public enum SelectImageType {
    case `default`
    case camera
    case photoAlbum
}
public class OpenPhotoConfiger {
    public init() {}
    public var selectImageType: SelectImageType = .default
    public var maxImageCount: UInt = 1
    public var imagesSubject: PublishSubject<[UIImage]> = PublishSubject()
}
extension OpenPhotoConfiger {
    public func config(_ closure: (OpenPhotoConfiger) -> Void) -> Self {
        closure(self)
        return self
    }
    public func maxCount(_ count: UInt) -> Self {
        self.maxImageCount = count
        return self
    }
    public func selectType(_ type: SelectImageType) -> Self {
        self.selectImageType = type
        return self
    }
}
