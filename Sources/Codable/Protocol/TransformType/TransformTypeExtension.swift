import CoreGraphics
// ZJaDe: gyb自动生成

// ZJaDe: Bool类型转换
extension Bool: TransformTypeProtocol {
    public var int: Int { self ? 1 : 0 }
    public var float: Float { self ? 1 : 0 }
    public var double: Double { self ? 1 : 0 }
    public var cgfloat: CGFloat { self ? 1 : 0 }
    public var bool: Bool { self }
}
// ZJaDe: String类型转换
extension String: TransformTypeProtocol {
    public var int: Int { intIfExist ?? 0 }
    public var float: Float { floatIfExist ?? 0 }
    public var double: Double { doubleIfExist ?? 0 }
    public var cgfloat: CGFloat { cgfloatIfExist ?? 0 }
}
// ZJaDe: Double类型转换
extension Double: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { self }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Float类型转换
extension Float: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { self }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: CGFloat类型转换
extension CGFloat: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { self }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Int类型转换
extension Int: TransformTypeProtocol {
    public var int: Int { self }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Int8类型转换
extension Int8: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Int16类型转换
extension Int16: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Int32类型转换
extension Int32: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: Int64类型转换
extension Int64: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: UInt类型转换
extension UInt: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: UInt8类型转换
extension UInt8: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: UInt16类型转换
extension UInt16: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: UInt32类型转换
extension UInt32: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
// ZJaDe: UInt64类型转换
extension UInt64: TransformTypeProtocol {
    public var int: Int { Int(self) }
    public var float: Float { Float(self) }
    public var double: Double { Double(self) }
    public var cgfloat: CGFloat { CGFloat(self) }
    public var bool: Bool { self != 0 }
}
