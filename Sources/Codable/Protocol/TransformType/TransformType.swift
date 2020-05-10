//
//  TransformType.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/11/17.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public protocol TransformTypeProtocol {
    var cgfloat: CGFloat {get}
    var float: Float {get}
    var double: Double {get}
    var int: Int {get}
}

extension Int {
    public var uInt: UInt {
        if self >= 0 {
            return UInt(self)
        } else {
            return 0
        }
    }
}
extension String {
    public var intIfExist: Int? {return Int(self) ?? double.int }
    public var cgfloatIfExist: CGFloat? {return doubleIfExist?.cgfloat}
    public var doubleIfExist: Double? {return Double(self)}
    public var floatIfExist: Float? {return Float(self)}
    public var nsString: NSString {
        self as NSString
    }

    public var bool: Bool? {
        let trimmed = self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "true", "1", "yes", "y":
            return true
        case "false", "0", "no", "n":
            return false
        default:
            return nil
        }
    }
}
extension CustomStringConvertible {
    public var string: String {
        "\(self)"
    }
}
extension CustomDebugStringConvertible where Self: CustomStringConvertible {
    public var debugDescription: String {
        self.description
    }
}
