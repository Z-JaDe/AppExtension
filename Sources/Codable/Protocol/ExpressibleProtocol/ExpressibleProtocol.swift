// ZJaDe: gyb自动生成

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
        self.init(value: value.toInt)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.toInt)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.toInt)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.toInt)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension FloatLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.toDouble)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.toDouble)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.toDouble)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.toDouble)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension StringLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.toString)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.toString)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.toString)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.toString)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
extension BooleanLiteralTypeValueProtocol where Self: ExpressibleValueProtocol {
    public init(booleanLiteral value: Bool) {
        self.init(value: value.toBool)
    }
    public init(integerLiteral value: Int) {
        self.init(value: value.toBool)
    }
    public init(floatLiteral value: Double) {
        self.init(value: value.toBool)
    }
    public init(stringLiteral value: String) {
        self.init(value: value.toBool)
    }
    public init(nilLiteral: ()) {
        self.init(value: nil)
    }
}
