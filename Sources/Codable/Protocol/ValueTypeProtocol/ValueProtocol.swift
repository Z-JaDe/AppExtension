// ZJaDe: gyb自动生成

public protocol ValueProtocol {
    associatedtype ValueType
    var value: ValueType {get}
    init(value: ValueType?)
}
extension Comparable where Self: ValueProtocol, Self.ValueType: Comparable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}
extension CustomStringConvertible where Self: ValueProtocol, Self.ValueType: CustomStringConvertible {
    public var description: String {
        "\(self.value)"
    }
}

// MARK: -
// ZJaDe: IntegerLiteralTypeValueProtocol
public protocol IntegerLiteralTypeValueProtocol: ValueProtocol where ValueType == IntegerLiteralType {
}
// ZJaDe: FloatLiteralTypeValueProtocol
public protocol FloatLiteralTypeValueProtocol: ValueProtocol where ValueType == FloatLiteralType {
    var positiveFormat: String {get}
}
// ZJaDe: StringLiteralTypeValueProtocol
public protocol StringLiteralTypeValueProtocol: ValueProtocol where ValueType == StringLiteralType {
}
// ZJaDe: BooleanLiteralTypeValueProtocol
public protocol BooleanLiteralTypeValueProtocol: ValueProtocol where ValueType == BooleanLiteralType {
}
