//
//  ListSection.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/15.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

open class ListSection: HiddenStateDesignable {
    public required init() {}

    // MARK: - HiddenStateDesignable
    open var isHidden: Bool = false
}
extension ListSection: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    public static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
