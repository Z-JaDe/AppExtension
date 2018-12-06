//
//  TransformType.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/17.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public protocol TransformTypeProtocol {
    var toCGFloat: CGFloat {get}
    var toFloat: Float {get}
    var toDouble: Double {get}
    var toInt: Int {get}
}

extension Int {
    public var toUInt: UInt {
        if self >= 0 {
            return UInt(self)
        } else {
            return 0
        }
    }
}
extension String {
    public var toIntIfExist: Int? {return Int(self) ?? toDouble.toInt }
    public var toCGFloatIfExist: CGFloat? {return toDoubleIfExist?.toCGFloat}
    public var toDoubleIfExist: Double? {return Double(self)}
    public var toFloatIfExist: Float? {return Float(self)}
    public var toNSString: NSString {
        return self as NSString
    }

    public var toBool: Bool? {
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
    public var toString: String {
        return "\(self)"
    }
}
extension CustomDebugStringConvertible where Self: CustomStringConvertible {
    public var debugDescription: String {
        return self.description
    }
}
