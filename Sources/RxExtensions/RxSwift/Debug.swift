//
//  Debug.swift
//  JDKit
//
//  Created by ZJaDe on 2017/12/20.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
extension ObservableType {
    public func logDebug(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> Observable<Element> {
        #if DEBUG || Beta || POD_CONFIGURATION_BETA
            return self.debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
        #else
            return self
        #endif
    }
}
extension PrimitiveSequence {
    public func logDebug(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function)
        -> Self {
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
                return self.debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
            #else
                return self
            #endif
    }
}
