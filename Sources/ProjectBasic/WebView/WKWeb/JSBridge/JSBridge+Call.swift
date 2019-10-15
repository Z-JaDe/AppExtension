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
private func encode<T: Encodable>(_ value: T) -> String {
    // swiftlint:disable force_try
    return String(data: try! JSBridge.encoder.encode([value]).dropFirst().dropLast(), encoding: .utf8)!
}
private func decode<T: Decodable>(_ jsonString: String) throws -> T {
    let data = ("[" + jsonString + "]").data(using: .utf8)!
    return (try JSBridge.decoder.decode([T].self, from: data))[0]
}
extension JSBridge {
    internal func call(function: String, withStringifiedArgs args: String) -> Observable<Void> {
        context.rawCall(function: function, args: args).mapToVoid()
    }

    internal func call<Result: Decodable>(function: String, withStringifiedArgs args: String) -> Observable<Result> {
        context.rawCall(function: function, args: args).map(decode)
    }

    public func call(function: String) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "")
    }

    public func call<A: Encodable>(function: String, withArg arg: A) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(arg))")
    }

    public func call<A: Encodable, B: Encodable>(function: String, withArgs args: (A, B)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1))")
    }
    // swiftlint:disable large_tuple
    public func call<A: Encodable, B: Encodable, C: Encodable>(function: String, withArgs args: (A, B, C)) -> Observable<Void> {
        // swiftlint:disable large_tuple
        return call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2))")
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable>(function: String, withArgs args: (A, B, C, D)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3))")
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(function: String, withArgs args: (A, B, C, D, E)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4))")
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(function: String, withArgs args: (A, B, C, D, E, F)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5))")
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5)),\(encode(args.6))")
    }

    public func call<A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G, H)) -> Observable<Void> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5)),\(encode(args.6)),\(encode(args.7))")
    }

    public func call<Result: Decodable>(function: String) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "")
    }

    public func call<Result: Decodable, A: Encodable>(function: String, withArg arg: A) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(arg))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable>(function: String, withArgs args: (A, B)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable>(function: String, withArgs args: (A, B, C)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable>(function: String, withArgs args: (A, B, C, D)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable>(function: String, withArgs args: (A, B, C, D, E)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable>(function: String, withArgs args: (A, B, C, D, E, F)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5)),\(encode(args.6))")
    }

    public func call<Result: Decodable, A: Encodable, B: Encodable, C: Encodable, D: Encodable, E: Encodable, F: Encodable, G: Encodable, H: Encodable>(function: String, withArgs args: (A, B, C, D, E, F, G, H)) -> Observable<Result> {
        call(function: function, withStringifiedArgs: "\(encode(args.0)),\(encode(args.1)),\(encode(args.2)),\(encode(args.3)),\(encode(args.4)),\(encode(args.5)),\(encode(args.6)),\(encode(args.7))")
    }
}
extension JSBridge {
    private func rawRegister(namespace: String) {
        self.context.register(namespace: namespace)
    }

    private func rawRegister(functionNamed name: String, _ fn: @escaping ([String]) throws -> Observable<String>) {
        self.context.register(functionNamed: name, fn)
    }

    public func register(namespace: String) {
        rawRegister(namespace: namespace)
    }

    public func register(functionNamed name: String, _ fn: @escaping () throws -> Void) {
        rawRegister(functionNamed: name) { _ in try fn(); return Observable.just("null") }
    }

    public func register<A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping (A, B) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6])); return Observable.just("null") }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G, H) throws -> Void) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6]), decode($0[7])); return Observable.just("null") }
    }

    public func register(functionNamed name: String, _ fn: @escaping () throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { _ in try fn().map { "null" } }
    }

    public func register<A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping (A, B) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6])).map { "null" } }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G, H) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6]), decode($0[7])).map { "null" } }
    }

    public func register<Return: Encodable>(functionNamed name: String, _ fn: @escaping () throws -> Return) {
        rawRegister(functionNamed: name) { _ in Observable.just(encode(try fn())) }
    }

    public func register<Return: Encodable, A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping (A, B) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6])))) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G, H) throws -> Return) {
        rawRegister(functionNamed: name) { Observable.just(encode(try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6]), decode($0[7])))) }
    }

    public func register<Return: Encodable>(functionNamed name: String, _ fn: @escaping () throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { _ in try fn().map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping (A, B) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6])).map { encode($0) } }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping (A, B, C, D, E, F, G, H) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { try fn(decode($0[0]), decode($0[1]), decode($0[2]), decode($0[3]), decode($0[4]), decode($0[5]), decode($0[6]), decode($0[7])).map { encode($0) } }
    }
}
