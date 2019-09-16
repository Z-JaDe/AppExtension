// ZJaDe: gyb自动生成

public typealias Calculatable = AddCalculatable & MinusCalculatable
extension Int: Calculatable {}
extension Double: Calculatable {}

// ZJaDe: Add: +
public protocol AddCalculatable {
    static func += (left: inout Self, right: Self)
    static func + (left: Self, right: Self) -> Self
}
public extension AddCalculatable where Self: ValueProtocol, Self.ValueType: AddCalculatable {
    static func += (left: inout Self, right: Self) {
        left = Self(value: left.value + right.value)
    }
    static func + (left: Self, right: Self) -> Self {
        Self(value: left.value + right.value)
    }
}
public extension Optional where Wrapped: AddCalculatable & ValueProtocol, Wrapped.ValueType: AddCalculatable {
    static func += (left: inout Wrapped?, right: Wrapped?) {
        let leftValue = left?.value ?? Wrapped(value: nil).value
        let rightValue = right?.value ?? Wrapped(value: nil).value
        left = Wrapped(value: leftValue + rightValue)
    }
    static func + (left: Wrapped?, right: Wrapped?) -> Wrapped {
        let leftValue = left?.value ?? Wrapped(value: nil).value
        let rightValue = right?.value ?? Wrapped(value: nil).value
        return Wrapped(value: leftValue + rightValue)
    }
}
// ZJaDe: Minus: -
public protocol MinusCalculatable {
    static func -= (left: inout Self, right: Self)
    static func - (left: Self, right: Self) -> Self
}
public extension MinusCalculatable where Self: ValueProtocol, Self.ValueType: MinusCalculatable {
    static func -= (left: inout Self, right: Self) {
        left = Self(value: left.value - right.value)
    }
    static func - (left: Self, right: Self) -> Self {
        Self(value: left.value - right.value)
    }
}
public extension Optional where Wrapped: MinusCalculatable & ValueProtocol, Wrapped.ValueType: MinusCalculatable {
    static func -= (left: inout Wrapped?, right: Wrapped?) {
        let leftValue = left?.value ?? Wrapped(value: nil).value
        let rightValue = right?.value ?? Wrapped(value: nil).value
        left = Wrapped(value: leftValue - rightValue)
    }
    static func - (left: Wrapped?, right: Wrapped?) -> Wrapped {
        let leftValue = left?.value ?? Wrapped(value: nil).value
        let rightValue = right?.value ?? Wrapped(value: nil).value
        return Wrapped(value: leftValue - rightValue)
    }
}
