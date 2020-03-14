//
//  StaticTableItemCell.swift
//  SNKit_ZJMax
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class StaticTableItemCell: TableItemCell {
    open var appearAnimation: CellAppearAnimationType = .zoomZ
    // MARK: -
    open override func configInit() {
        super.configInit()

        self.didLayoutSubviewsClosure = { ($0 as? Self)?.updateHeight() }
    }
    open override func willAppear() {
        super.willAppear()
        configAppearAnimate()
    }
    open func configAppearAnimate() {
        configAppearAnimate(appearAnimation)
    }

    // MARK: - CheckAndCatchParamsProtocol
    public var key: String = ""
    public var catchParamsErrorPrompt: String?
    public var catchParamsClosure: CatchParamsClosure?
    public var checkParamsClosure: CheckParamsClosure?
}
extension StaticTableItemCell: CellSelectedStateDesignable {}
