//
//  ClassNameDesignable.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol ClassNameDesignable: AnyObject {
    var classFullName: String {get}
    static var classFullName: String {get}

    var className: String {get}
    static var className: String {get}
}
extension ClassNameDesignable {
    public var classFullName: String {
        type(of: self).classFullName
    }
    public static var classFullName: String {
        NSStringFromClass(self)
    }

    public var className: String {
        type(of: self).className
    }
    public static var className: String {
        String(classFullName.split(separator: ".").last ?? "")
    }
}
extension NSObject: ClassNameDesignable {}
