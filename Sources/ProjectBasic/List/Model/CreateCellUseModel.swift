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
    func didChangedModel(_ model: _ModelType)
}
extension DynamicModelCell {
    func getModel() -> _ModelType? {
        _model
    }
    func setModel(_ model: _ModelType?) {
        _model = model
    }
}
/// 刚开始cell还没有被添加到视图层次的时候，先通过model强引用，cell弱引用model(并绑定数据) 避免循环引用
/// 被添加到视图层次以后，model对cell的持有转变为弱引用，cell对model的持有变为强引用
protocol CreateCellUseModel: class {
    associatedtype CellType: UIView & DynamicModelCell where CellType._ModelType == Self
    var _weakContentCell: CellType? {get set}

    func createCell(isTemp: Bool) -> CellType
}
extension CreateCellUseModel {
    func getCell() -> CellType? {
        _weakContentCell
    }
    func createCellIfNil() -> CellType {
        if let cell = _weakContentCell {
            return cell
        }
        let cell = createCell(isTemp: false)
        cell._model = self
        self._weakContentCell = cell
        return cell
    }
    func cleanCellReference() {
        getCell()?._model = nil
        self._weakContentCell = nil
    }
}
