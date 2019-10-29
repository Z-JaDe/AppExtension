//
//  JSBridge+Register.swift
//  ProjectBasic
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

extension JSBridge: DisposeBagProtocol {
    private func rawRegister(namespace: String) {
        self.context.register(namespace: namespace)
    }

    private func rawRegister(functionNamed name: String, _ fn: @escaping ([String]) throws -> Observable<String>) {
        self.context.register(functionNamed: name, fn)
    }

    public func register(namespace: String) {
        rawRegister(namespace: namespace)
    }
}
extension JSBridge {
    public func registerArgs(functionNamed name: String, _ fn: @escaping (JSBridgeArgs) throws -> Void) {
        rawRegister(functionNamed: name) { (args) in
            try fn(JSBridgeArgs(args: args))
            return Observable.just("null")
        }
    }

    public func register(functionNamed name: String, _ fn: @escaping () throws -> Void) {
        registerArgs(functionNamed: name) { _ in try fn() }
    }

    public func register<A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G, H)) throws -> Void) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }
}
extension JSBridge {
    public func registerArgs(functionNamed name: String, _ fn: @escaping (JSBridgeArgs) throws -> Observable<Void>) {
        rawRegister(functionNamed: name) { (args) in
            try fn(JSBridgeArgs(args: args)).map { "null" }
        }
    }

    public func register(functionNamed name: String, _ fn: @escaping () throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { _ in try fn() }
    }

    public func register<A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G, H)) throws -> Observable<Void>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }
}
extension JSBridge {
    public func registerArgs<Return: Encodable>(functionNamed name: String, _ fn: @escaping (JSBridgeArgs) throws -> Return) {
        rawRegister(functionNamed: name) { (args) in
            Observable.just(JSBridgeArgs.encode(try fn(JSBridgeArgs(args: args))))
        }
    }

    public func register<Return: Encodable>(functionNamed name: String, _ fn: @escaping () throws -> Return) {
        registerArgs(functionNamed: name) { _ in try fn() }
    }

    public func register<Return: Encodable, A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G, H)) throws -> Return) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }
}
extension JSBridge {
    public func registerArgs<Return: Encodable>(functionNamed name: String, _ fn: @escaping (JSBridgeArgs) throws -> Observable<Return>) {
        rawRegister(functionNamed: name) { (args) in
            try fn(JSBridgeArgs(args: args)).map(JSBridgeArgs.encode)
        }
    }

    public func register<Return: Encodable>(functionNamed name: String, _ fn: @escaping () throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { _ in try fn() }
    }

    public func register<Return: Encodable, A: Decodable>(functionNamed name: String, _ fn: @escaping (A) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }

    public func register<Return: Encodable, A: Decodable, B: Decodable, C: Decodable, D: Decodable, E: Decodable, F: Decodable, G: Decodable, H: Decodable>(functionNamed name: String, _ fn: @escaping ((A, B, C, D, E, F, G, H)) throws -> Observable<Return>) {
        registerArgs(functionNamed: name) { try fn($0.map()) }
    }
}
