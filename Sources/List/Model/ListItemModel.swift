//
//  ListItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/8.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class ListItemModel: Model, AdapterItemType & CanSelectedStateDesignable & HiddenStateDesignable & EnabledStateDesignable, NeedUpdateProtocol {
    var hasLoad: Bool = false
    // MARK: - ID
    open lazy var reuseIdentifier: String = self.cellFullName

    open lazy var cellFullName: String = {
        var name: String = self.getCellName(self.classFullName)
        return name
    }()
    open func cellClass(_ reuseIdentifier: String) -> AnyClass {
        jdAbstractMethod()
    }
    open var viewNameSuffix: String {
        return "Cell"
    }
    // MARK: -
    open func isContentEqual(to source: ListItemModel) -> Bool {
        return self.identity == source.identity
    }
    private var identity: String {
        return "\(self.hashValue)\(self.needUpdateSentinel.value)"
    }
    public var isHidden: Bool = false
    // MARK: -
    private var needUpdateSentinel: Sentinel = Sentinel()
    public func setNeedUpdate() {
        self.needUpdateSentinel.increase()
    }
    // MARK: -
    public var isSelected: Bool = false
    public var canSelected: Bool = false
    public func didSelectItem() {
        jdAbstractMethod()
    }
    open func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }
    // MARK: -
    open var isEnabled: Bool? {
        didSet {
            if let isEnabled = self.isEnabled, isEnabled != oldValue {
                updateEnabledState(isEnabled)
            }
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {

    }
}
extension ListItemModel {
    public func getCellName(_ modelName: String) -> String {
        let range = modelName.index(modelName.endIndex, offsetBy: -5) ..<  modelName.endIndex
        return modelName.replacingCharacters(in: range, with: self.viewNameSuffix)
    }
}
