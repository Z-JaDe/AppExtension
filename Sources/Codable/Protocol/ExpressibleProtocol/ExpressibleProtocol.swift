// ZJaDe: gyb自动生成
// swiftlint:disable colon
public protocol ExpressibleValueProtocol:
    ExpressibleByBooleanLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByStringLiteral,
    ExpressibleByNilLiteral {

    init(booleanLiteral value: Bool)
    init(integerLiteral value: Int)
    init(floatLiteral value: Double)
    init(stringLiteral value: String)
    init(nilLiteral: ())
}
extension ExpressibleValueProtocol {
    public init(_ value: Bool?) {
        if let value = value {
            self.init(booleanLiteral: value)
        } else {
            self.init(nilLiteral: ())
        }
    }
    public init(_ value: Int?) {
        if let value = value {
            self.init(integerLiteral: value)
        } else {
            self.init(nilLiteral: ())
        }
    }
    public init(_ value: Double?) {
        if let value = value {
            self.init(floatLiteral: value)
        } else {
            self.init(nilLiteral: ())
        }
    }
    public init(_ value: String?) {
        if let value = value {
            self.init(stringLiteral: value)
        } else {
            self.init(nilLiteral: ())
        }
    }
}
extension IntegerLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.int)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.int)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.int)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.int)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension FloatLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.double)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.double)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.double)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.double)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension StringLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.string)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.string)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.string)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.string)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension BooleanLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.bool)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.bool)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.bool)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.bool)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
