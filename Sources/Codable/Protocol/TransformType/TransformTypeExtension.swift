// ZJaDe: gyb自动生成

// ZJaDe: Bool类型转换
extension Bool: TransformTypeProtocol {
    public var toInt: Int { return self ? 1 : 0 }
    public var toFloat: Float { return self ? 1 : 0 }
    public var toDouble: Double { return self ? 1 : 0 }
    public var toCGFloat: CGFloat { return self ? 1 : 0 }
    public var toBool: Bool { return self }
}
// ZJaDe: String类型转换
extension String: TransformTypeProtocol {
    public var toInt: Int { return toIntIfExist ?? 0 }
    public var toFloat: Float { return toFloatIfExist ?? 0 }
    public var toDouble: Double { return toDoubleIfExist ?? 0 }
    public var toCGFloat: CGFloat { return toCGFloatIfExist ?? 0 }
}
// ZJaDe: Double类型转换
extension Double: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return self }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Float类型转换
extension Float: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return self }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: CGFloat类型转换
extension CGFloat: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return self }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Int类型转换
extension Int: TransformTypeProtocol {
    public var toInt: Int { return self }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Int8类型转换
extension Int8: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Int16类型转换
extension Int16: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Int32类型转换
extension Int32: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: Int64类型转换
extension Int64: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: UInt类型转换
extension UInt: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: UInt8类型转换
extension UInt8: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: UInt16类型转换
extension UInt16: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: UInt32类型转换
extension UInt32: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
// ZJaDe: UInt64类型转换
extension UInt64: TransformTypeProtocol {
    public var toInt: Int { return Int(self) }
    public var toFloat: Float { return Float(self) }
    public var toDouble: Double { return Double(self) }
    public var toCGFloat: CGFloat { return CGFloat(self) }
    public var toBool: Bool { return self != 0 }
}
