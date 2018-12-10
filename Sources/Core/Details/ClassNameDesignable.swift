//
//  ClassNameDesignable.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol ClassNameDesignable: class {
    var classFullName: String {get}
    static var classFullName: String {get}

    var className: String {get}
    static var className: String {get}
}
extension ClassNameDesignable {
    public var classFullName: String {
        return type(of: self).classFullName
    }
    public static var classFullName: String {
        return NSStringFromClass(self)
    }

    public var className: String {
        return type(of: self).className
    }
    public static var className: String {
        return String(classFullName.split(separator: ".").last ?? "")
    }
}
extension NSObject: ClassNameDesignable {}
