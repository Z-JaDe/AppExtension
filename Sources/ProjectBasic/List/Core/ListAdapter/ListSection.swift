//
//  ListSection.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/15.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift

open class ListSection: Hashable,
    ClassNameDesignable,
    AdapterSectionType {
    public required init() {}

    // MARK: - HiddenStateDesignable
    open var isHidden: Bool = false
}
extension ListSection {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(Unmanaged.passUnretained(self).toOpaque())")
    }
    public static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
