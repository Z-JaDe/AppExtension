//
//  ConfigModelProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/9/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol ConfigModelProtocol: class {
    associatedtype ModelType
    var model: ModelType {get set}
    /// 不能通过直接调用的方式，应该使用设置model的方式
    func configData(with model: ModelType)

    func updateWithModel()
    func update(with model: ModelType)
}
public extension ConfigModelProtocol {
    func updateWithModel() {
        self.update(with: self.model)
    }
    func update(with model: ModelType) {
        self.model = model
    }
}
public protocol ConfigOptionModelProtocol: class {
    associatedtype ModelType
    var model: ModelType? {get set}
    /// 不能通过直接调用的方式，应该使用设置model的方式
    func configData(with model: ModelType?)

    func updateWithModel()
    func update(with model: ModelType?)
}
public extension ConfigOptionModelProtocol {
    func updateWithModel() {
        self.update(with: self.model)
    }
    func update(with model: ModelType?) {
        self.model = model
    }
}

public protocol ConfigViewModelProtocol: class {
    associatedtype ViewModelType
    var viewModel: ViewModelType! {get set}
    /// 不能通过直接调用的方式，应该使用设置model的方式
    func config(viewModel: ViewModelType)
}
extension ConfigViewModelProtocol {
    func updateWithViewModel() {
        if let viewModel = self.viewModel {
            self.update(viewModel: viewModel)
        }
    }
    func update(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }
}
