// ZJaDe: gyb自动生成

// ZJaDe: Bool类型转换
extension Bool: TransformTypeProtocol {
    public var toInt: Int { self ? 1 : 0 }
    public var toFloat: Float { self ? 1 : 0 }
    public var toDouble: Double { self ? 1 : 0 }
    public var toCGFloat: CGFloat { self ? 1 : 0 }
    public var toBool: Bool { self }
}
// ZJaDe: String类型转换
extension String: TransformTypeProtocol {
    public var toInt: Int { toIntIfExist ?? 0 }
    public var toFloat: Float { toFloatIfExist ?? 0 }
    public var toDouble: Double { toDoubleIfExist ?? 0 }
    public var toCGFloat: CGFloat { toCGFloatIfExist ?? 0 }
}
// ZJaDe: Double类型转换
extension Double: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { self }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Float类型转换
extension Float: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { self }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: CGFloat类型转换
extension CGFloat: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { self }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Int类型转换
extension Int: TransformTypeProtocol {
    public var toInt: Int { self }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Int8类型转换
extension Int8: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Int16类型转换
extension Int16: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Int32类型转换
extension Int32: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: Int64类型转换
extension Int64: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: UInt类型转换
extension UInt: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: UInt8类型转换
extension UInt8: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: UInt16类型转换
extension UInt16: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: UInt32类型转换
extension UInt32: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
// ZJaDe: UInt64类型转换
extension UInt64: TransformTypeProtocol {
    public var toInt: Int { Int(self) }
    public var toFloat: Float { Float(self) }
    public var toDouble: Double { Double(self) }
    public var toCGFloat: CGFloat { CGFloat(self) }
    public var toBool: Bool { self != 0 }
}
