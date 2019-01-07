//
//  CoreTests.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/3.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import XCTest
@testable import Core
class CoreTests: XCTestCase {
    func testLazy() {
        let a = aaa([1,2,3,4,5,6,7,8,11,10]).map { (value) -> String in
            print("map\(value)")
            return "\(value)"
        }
        print("A")
        print(a.first {Int($0)! > 7}!)
    }
    func aaa(_ array: [Int]) -> LazyFilterCollection<[Int]> {
        return array.lazy.filter({ (value) -> Bool in
            print("filter\(value)")
            return value > 4
        })
    }
}
