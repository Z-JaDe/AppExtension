//
//  AutoreleaseTests.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import XCTest
/** ZJaDe:
 swift中
 1、单纯静态方法返回的参数应该不会添加到自动释放池中，因为没有看到内存疯长
 2、如果使用Date、NSDate、NumberFormatter、NSData等等创建实例，然后调用 print(date) 会导致内存疯长，经测试是被添加到自动释放池里面了，应该是这些结构体或者类实现的内部description方法里面，涉及到oc的东西
 如果自己创建一个结构体或者类，或者使用Data、NSObject等等创建实例，内存基本保持平稳

 po: print打印的字符串长度越长 越消耗性能
 */
class AutoreleaseTests: XCTestCase {
    func testRelease() {
        print("1")
        for _ in 0...500000 {
            do {
            }
            autoreleasepool {
            }
            let object = NSData()
            print(object)
        }
        print("2")
        Thread.sleep(forTimeInterval: 2)
        print("3")
    }
}
extension NSObject {
    fileprivate static func object() -> NSObject {
        let data = NSObject()
        return data
    }
}
private struct Person: CustomStringConvertible {
    let name: Int = 0

    var description: String {
        return "\(self.name)"
    }
}
