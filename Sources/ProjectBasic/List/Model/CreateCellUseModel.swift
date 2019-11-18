//
//  CreateCellUseModel.swift
//  ProjectBasic
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
protocol DynamicModelCell: class {
    associatedtype _ModelType
    var _model: _ModelType? {get set}
    var _weakModel: _ModelType? {get set}
    func didChangedModel(_ model: _ModelType)
}
extension DynamicModelCell {
    fileprivate func cleanReference() {
        self._model = nil
        self._weakModel = nil
    }
    func getModel() -> _ModelType? {
        _weakModel ?? _model
    }
    func setModel(_ model: _ModelType?) {
        _weakModel = model
        if _model != nil {
            _model = model
        }
    }
}
/// 刚开始cell还没有被添加到视图层次的时候，先通过model强引用，cell弱引用model(并绑定数据) 避免循环引用
/// 被添加到视图层次以后，model对cell的持有转变为弱引用，cell对model的持有变为强引用
protocol CreateCellUseModel: class {
    associatedtype CellType: UIView & DynamicModelCell where CellType._ModelType == Self
    var _contentCell: CellType? {get set}
    var _weakContentCell: CellType? {get set}

    func createCell(isTemp: Bool) -> CellType
}
extension CreateCellUseModel {
    func didCreate(cell: CellType) {
        self._contentCell = cell
        cell._weakModel = self
    }
    func cellDidInHierarchy() {
        if _contentCell == nil {
            logError("cell为空，需检查错误")
        }
        let cell = self._contentCell
        self._weakContentCell = cell
        self._contentCell = nil

        cell?._model = self
    }
    func getCell() -> CellType? {
        _weakContentCell ?? _contentCell
    }
    func createCellIfNil() {
        guard _contentCell == nil && _weakContentCell == nil else {
            return
        }
        let cell = createCell(isTemp: false)
        didCreate(cell: cell)
    }
    func cleanCellReference() {
        getCell()?.cleanReference()
        self._contentCell = nil
        self._weakContentCell = nil
    }
}
