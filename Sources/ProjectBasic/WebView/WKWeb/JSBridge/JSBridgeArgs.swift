//
//  JSBridgeArgs.swift
//  ProjectBasic
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public struct JSBridgeArgs {
    let args: [String]
    public func decode<T: Decodable>(_ index: Int) throws -> T {
        if args.indexCanBound(index) {
            return try JSBridgeArgs.decode(args[index])
        } else {
            throw NSError(domain: "com.zjade.jsBridge.decode", code: -1, userInfo: nil)
        }
    }
}
extension JSBridgeArgs {
    public static func encode<T: Encodable>(_ value: T) -> String {
        // swiftlint:disable force_try
        return String(data: try! JSBridge.encoder.encode([value]).dropFirst().dropLast(), encoding: .utf8)!
    }
    public static func decode<T: Decodable>(_ jsonString: String) throws -> T {
        let data = ("[" + jsonString + "]").data(using: .utf8)!
        return (try JSBridge.decoder.decode([T].self, from: data))[0]
    }
}
public extension JSBridgeArgs {
    func map<A: Decodable>() throws -> A {
        return try decode(0)
    }
    func map<A: Decodable, B: Decodable>() throws -> (A, B) {
        return try (decode(0), decode(1))
    }
    func map<A: Decodable, B: Decodable, C: Decodable>() throws -> (A, B, C) {
        return try (decode(0), decode(1), decode(2))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable>() throws -> (A, B, C, D) {
        return try (decode(0), decode(1), decode(2), decode(3))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>() throws -> (A, B, C, D, E) {
        return try (decode(0), decode(1), decode(2), decode(3), decode(4))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>() throws -> (A, B, C, D, E, F) {
        return try (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>() throws -> (A, B, C, D, E, F, G) {
        return try (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5), decode(6))
    }
    func map<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>() throws -> (A, B, C, D, E, F, G, H) {
        return try (decode(0), decode(1), decode(2), decode(3), decode(4), decode(5), decode(6), decode(7))
    }
}
public extension JSBridgeArgs {
    static func map<A: Encodable>(_ args: A) -> [String] {
        return [encode(args)]
    }
    static func map<A: Encodable, B: Encodable>(_ args: (A, B)) -> [String] {
        return [encode(args.0), encode(args.1)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable>(_ args: (A, B, C)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable>(_ args: (A, B, C, D)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2), encode(args.3)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(_ args: (A, B, C, D, E)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(_ args: (A, B, C, D, E, F)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(_ args: (A, B, C, D, E, F, G)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5), encode(args.6)]
    }
    static func map<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(_ args: (A, B, C, D, E, F, G, H)) -> [String] {
        return [encode(args.0), encode(args.1), encode(args.2), encode(args.3), encode(args.4), encode(args.5), encode(args.6), encode(args.7)]
    }
}
