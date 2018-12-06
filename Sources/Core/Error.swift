//
//  Error.swift
//  AppInfoData
//
//  Created by 茶古电子商务 on 2017/11/28.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

open class AppError: Error {
    let errorCode: Int
    var errorDescription: String

    public init(_ errorCode: Int, errorDescription: String) {
        self.errorCode = errorCode
        self.errorDescription = errorDescription
    }
    var localizedDescription: String {
        return "zjadeError: \(errorCode), \(errorDescription)"
    }

    open class var nilError: AppError {
        return AppError(11, errorDescription: "值为nil")
    }

    open class var deallocError: AppError {
        return AppError(12, errorDescription: "对象已经释放")
    }

}
