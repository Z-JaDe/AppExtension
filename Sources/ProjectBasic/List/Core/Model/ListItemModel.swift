//
//  ListItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/8.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class ListItemModel: Hashable {
    public init() {}
    public lazy var cellInfo: CellInfo = CellInfo(modelName: self.classFullName)
    // MARK: NeedUpdateProtocol
    private(set) var needUpdateSentinel: Sentinel = Sentinel()
    // MARK: HiddenStateDesignable
    public var isHidden: Bool = false

    // MARK: Hashable
    open func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    public static func == (lhs: ListItemModel, rhs: ListItemModel) -> Bool {
        lhs === rhs
    }
}
extension ListItemModel: NeedUpdateProtocol {
    // TODO: 还未实现
    public func setNeedUpdate() {
        self.needUpdateSentinel.increase()
    }
}
extension ListItemModel: ClassNameDesignable {
    public struct CellInfo {
        var nameSuffix: String
        var clsName: String
        var reuseIdentifier: String
        init(modelName: String) {
            self.nameSuffix = "Cell"
            self.clsName = Self.getCellName(modelName, nameSuffix)
            self.reuseIdentifier = clsName
        }
        static func getCellName(_ modelName: String, _ nameSuffix: String) -> String {
            let range = modelName.index(modelName.endIndex, offsetBy: -5) ..<  modelName.endIndex
            return modelName.replacingCharacters(in: range, with: nameSuffix)
        }
    }
}
