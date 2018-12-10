//
//  CustomTests.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/3.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import XCTest
@testable import ProjectBasic

var intkey: UInt8 = 0
var protocolkey: UInt8 = 0
class AssociatedObject: XCTestCase {
    func testInt() {
        typealias ValueType = Int?
        let value: ValueType = 22
        setAssociatedObject(&intkey, value)
        let associatedValue: ValueType = associatedObject(&intkey)
        print("associatedValue=\(String(describing: associatedValue))")
        XCTAssertTrue(associatedValue == value, "\(String(describing: associatedValue))")
    }
    func testNSObject() {
        typealias ValueType = NSObject?
        let value: ValueType = NSObject()
        setAssociatedObject(&intkey, value)
        let associatedValue: ValueType = associatedObject(&intkey)
        print("associatedValue=\(String(describing: associatedValue))")
        XCTAssertTrue(associatedValue == value, "\(String(describing: associatedValue))")
    }
    func testWeakObject() {
        typealias ValueType = NSObject?
        do {
            let value: ValueType = NSObject()
            setAssociatedWeakObject(&intkey, value)
            let associatedValue: ValueType = associatedObject(&intkey)
            print("associatedValue=\(String(describing: associatedValue))")
            XCTAssertTrue(associatedValue == value, "\(String(describing: associatedValue))")
        }
        let associatedValue: ValueType = associatedObject(&intkey)
        print("associatedValue=\(String(describing: associatedValue))")
        XCTAssertTrue(associatedValue == nil, "\(String(describing: associatedValue))")
    }
    func testProtocol() {
        typealias ValueType = Protocol
        let value: ValueType = "2"
        setAssociatedObject(&protocolkey, value)
        let associatedValue: ValueType? = associatedObject(&protocolkey)
        XCTAssertTrue((associatedValue as? String) == value as? String, "associatedValue == \(String(describing: associatedValue))")
    }
    func testClosure() {
        typealias ValueType = () -> Void
        let value: ValueType = {}
        setAssociatedObject(&protocolkey, value)
        let associatedValue: ValueType? = associatedObject(&protocolkey)
        XCTAssertTrue(associatedValue != nil, "associatedValue == \(String(describing: associatedValue))")
    }
}

private protocol Protocol {

}
extension String: Protocol {}

func testOptional() {
    let value: Int??? = 1
    let optionValue = value as? Int
    XCTAssertTrue(optionValue == value)
}
/// ZJaDe: A实现了和B相等的逻辑 B实现了和C相等的逻辑 A和C能否直接判断相等
