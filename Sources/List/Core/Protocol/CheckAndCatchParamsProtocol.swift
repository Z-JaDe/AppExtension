//
//  ModelParamsProtocol.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/22.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation

public typealias CheckAndCatchParamsProtocol = CheckParamsProtocol & CatchParamsProtocol

public typealias CheckParamsClosure = () -> Bool
public protocol CheckParamsProtocol {
    var key: String {get}
    var catchParamsErrorPrompt: String? {get}
    var checkParamsClosure: CheckParamsClosure? {get}
    func checkParams() -> Bool
}
extension CheckParamsProtocol {
    public var catchParamsErrorPrompt: String? {
        return nil
    }
    public var checkParamsClosure: CheckParamsClosure? {
        return nil
    }
}
// MARK: -
public typealias CatchParamsClosure = () -> [String: Any]
public protocol CatchParamsProtocol {
    var key: String {get}
    var catchParamsClosure: CatchParamsClosure? {get}
    func catchParams() -> [String: Any]
}
extension CatchParamsProtocol {
    public var catchParamsClosure: CatchParamsClosure? {
        return nil
    }
}

public protocol DataSourceItemsParamProtocol {
    func eachModel(_ closure: ((Any) -> Bool)) -> Bool

    func catchAllParams() -> [String: Any]
    func checkAllParams() -> Bool
    func checkAndCatchParams() -> [String: Any]?
}
extension DataSourceItemsParamProtocol {
    public func catchAllParams() -> [String: Any] {
        func catchModelParams(_ model: Any) -> [String: Any]? {
            guard let model = model as? CatchParamsProtocol else { return nil }
            if let model = model as? HiddenStateDesignable, model.isHidden == true { return nil }
            if let closure = model.catchParamsClosure {
                return closure()
            } else if !model.key.isEmpty {
                return model.catchParams()
            } else {
                return nil
            }
        }
        var params = [String: Any]()
        _ = eachModel { (model) -> Bool in
            if let modelParams = catchModelParams(model) {
                modelParams.forEach({ (map) in
                    params[map.0] = map.1
                })
            }
            return true
        }
        return params
    }
    public func checkAllParams() -> Bool {
        func checkModelParams(_ model: Any) -> Bool? {
            guard let model = model as? CheckParamsProtocol else {
                return nil
            }
            if let closure = model.checkParamsClosure {
                return closure()
            } else if model.key.isEmpty {
                return nil
            } else if model.checkParams() == false {
                return false
            }
            return true
        }
        var result = true
        _ = eachModel { (model) -> Bool in
            if checkModelParams(model) == false {
                result = false
                return false
            }
            return true
        }
        return result
    }
    public func checkAndCatchParams() -> [String: Any]? {
        if checkAllParams() {
            return catchAllParams()
        } else {
            return nil
        }
    }
}
// MARK: -
extension Array: DataSourceItemsParamProtocol {
    public func eachModel(_ closure: ((Any) -> Bool)) -> Bool {
        for element in self {
            let isContinue = closure(element)
            if !isContinue {
                return false
            }
        }
        return true
    }

}
