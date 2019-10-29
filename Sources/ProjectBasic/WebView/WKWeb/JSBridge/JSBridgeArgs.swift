//
//  JSBridgeArgs.swift
//  ProjectBasic
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
public protocol JSBridgeEmptyArg {
    init()
}
extension Int: JSBridgeEmptyArg {}
extension UInt: JSBridgeEmptyArg {}
extension Double: JSBridgeEmptyArg {}
extension Float: JSBridgeEmptyArg {}
extension String: JSBridgeEmptyArg {}
extension Optional: JSBridgeEmptyArg {
    public init() {
        self = .none
    }
}
public struct JSBridgeArgs {
    let args: [String]
    public typealias Decodable = Swift.Decodable & JSBridgeEmptyArg
    public typealias Encodable = Swift.Encodable & JSBridgeEmptyArg
}
public extension JSBridgeArgs {
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    static func encode<T: Encodable>(_ value: T) -> String {
        // swiftlint:disable force_try
        return String(data: try! encoder.encode(value), encoding: .utf8)!
    }
    static func decode<T: Decodable>(_ jsonString: String) -> T {
        do {
            let data = jsonString.data(using: .utf8)!
            return try decoder.decode(T.self, from: data)
        } catch {
            return T()
        }
    }
    func decode<T: Decodable>(_ index: Int) -> T {
        if args.indexCanBound(index) {
            return JSBridgeArgs.decode(args[index])
        } else {
            return T()
        }
    }
}
// swiftlint:disable large_tuple
extension JSBridgeArgs {
    func map<A: Decodable>() -> A {
        decode(0)
    }
    func map<A: Decodable, B: Decodable>() -> (A, B) {
        (decode(0), decode(1))
    }
    func map<A: Decodable, B: Decodable, C: Decodable>() -> (A, B, C) {
        (decode(0), decode(1), decode(2))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable>() -> (A, B, C, D) {
        (decode(0), decode(1), decode(2), decode(3))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>() -> (A, B, C, D, E) {
        (decode(0), decode(1), decode(2), decode(3), decode(4))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>() -> (A, B, C, D, E, F) {
        (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>() -> (A, B, C, D, E, F, G) {
        (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5), decode(6))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>() -> (A, B, C, D, E, F, G, H) {
        (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5), decode(6), decode(7))
    }
}
extension JSBridgeArgs {
    static func map<A: Encodable>(_ args: A) -> [String] {
        [encode(args)]
    }
    static func map<A: Encodable, B: Encodable>(_ args: (A, B)) -> [String] {
        [encode(args.0), encode(args.1)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable>(_ args: (A, B, C)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable>(_ args: (A, B, C, D)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2), encode(args.3)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(_ args: (A, B, C, D, E)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(_ args: (A, B, C, D, E, F)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(_ args: (A, B, C, D, E, F, G)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5), encode(args.6)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(_ args: (A, B, C, D, E, F, G, H)) -> [String] {
        [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5), encode(args.6), encode(args.7)]
    }
}
