//
//  JSBridge+Call.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/3/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
extension JSBridge {
    public static let encoder = JSONEncoder()
    public static let decoder = JSONDecoder()
}
// swiftlint:disable large_tuple
extension JSBridge {
    public func call(function: String, withArgs args: [String]) -> Observable<Void> {
        context.rawCall(function: function, args: args.joined(separator: ",")).mapToVoid()
    }

    public func call<Result: Decodable>(function: String, withArgs args: [String]) -> Observable<Result> {
        context.rawCall(function: function, args: args.joined(separator: ",")).map(JSBridgeArgs.decode)
    }

    public func call(function: String) -> Observable<Void> {
        context.rawCall(function: function, args: "").mapToVoid()
    }

    public func call<Result: Decodable>(function: String) -> Observable<Result> {
        context.rawCall(function: function, args: "").map(JSBridgeArgs.decode)
    }
}
extension JSBridge {
    public func call<A: Encodable>(function: String, withArg arg: A) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(arg))
    }

    public func call<A: Encodable, B: Encodable>(function: String, withArgs args: (A, B)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }
    public func call<A: Encodable, B: Encodable, C: Encodable>(function: String, withArgs args: (A, B, C)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable>(function: String, withArgs args: (A, B, C, D)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(function: String, withArgs args: (A, B, C, D, E)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(function: String, withArgs args: (A, B, C, D, E, F)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G, H)) -> Observable<Void> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }
}
extension JSBridge {
    public func call<Result: Decodable, A: Encodable>(function: String, withArg arg: A) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(arg))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable>(function: String, withArgs args: (A, B)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable>(function: String, withArgs args: (A, B, C)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable>(function: String, withArgs args: (A, B, C, D)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(function: String, withArgs args: (A, B, C, D, E)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(function: String, withArgs args: (A, B, C, D, E, F)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G, H)) -> Observable<Result> {
        call(function: function, withArgs: JSBridgeArgs.map(args))
    }
}
