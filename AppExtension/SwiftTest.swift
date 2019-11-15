//
//  SwiftTest.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/27.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import Core
import RxSwift
import RxExtensions

var observation: NSKeyValueObservation?
func swiftTest() {
    let a = A()
    let hash1 = ObjectIdentifier(a).debugDescription
    let hash2 = ObjectIdentifier(a).debugDescription
    print(hash1)
    print(hash2)
    let value = ~0
    print(value)
    greetings(person: Person()) // prints 'Hello'
    greetings(person: MisunderstoodPerson()) // prints 'Hello'

    B.aa = 2
    print(A.aa)
    print(B.aa)
    C().a()
}
class A {
    static var aa: Int = 0
}
class B: A {
}
@objc class Person: NSObject {
    @objc dynamic func sayHi() {
        print("Hello")
    }
}
extension Person {
}
func greetings(person: Person) {
    person.sayHi()
}
@objc class MisunderstoodPerson: Person {}
extension MisunderstoodPerson {
    @objc dynamic override func sayHi() {
        print("No one gets me.")
    }
}

protocol AAAA {
    func a()
}
extension AAAA {
    func a() {
    }
}
protocol BBBB {
    func a()
}
extension BBBB {
    func a() {
        
    }
}
public class C {
    public init() {}
//    func a() {
//        print("B")
//    }
}
extension C: AAAA, BBBB {
    func a() {
        print("A")
    }
}


// MARK: -
func mainColor() {
    DispatchQueue.main.async {
        let image:UIImage? = nil
        let window = UIApplication.shared.delegate?.window ?? nil
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = UIImage(named: "bank_abc")?.mainColor()
        window?.addSubview(view)
        var _image:UIColor?
        logTimer {
            _image = UIImage(named: "bank_abc")?.mainColor()
        }
        logDebug(_image)

        let imageView = UIImageView(image: image)
        imageView.left = view.right
        imageView.top = view.top
        window?.addSubview(imageView)
    }
}

//    func regex() {
//        var regex: [String] = []
//        let 汉字 = "\\u4E00-\\u9FA5"
//        let 字母数字 = "0-9A-Za-z"
//        regex.append("^((?![\(汉字)]+$)(?![\(字母数字)]+$)[\(汉字)\(字母数字)]){4, 16}$")
//        regex.append("^[\(汉字)]{2, 8}$")
//        regex.append("^[\(字母数字)]{4, 16}$")
//        let value = Regex(regex.joined(separator: "|")).test(testStr: "我们我们我们我们我们1")
//        logDebug(value)
//    }

func memoryLayoutTest() {
    print("Int")
    print(MemoryLayout<Int8>.size)
    print(MemoryLayout<Int16>.size)
    print(MemoryLayout<Int32>.size)
    print(MemoryLayout<Int64>.size)
    print(MemoryLayout<Int>.size)
    print("Float")
    print(MemoryLayout<Float32>.size)
    print(MemoryLayout<Float64>.size)
    print(MemoryLayout<Float>.size)
    print("Double")
    print(MemoryLayout<Double>.size)
    print("CGFloat")
    print(MemoryLayout<CGFloat>.size)
}

// MARK: -
func copyTest() {
    let a = TestArr()
    print("准备设置")
    a.array.countIsEqual(count: 6, append: {$0}, remove: {_ in })
    print("设置完成")
    
    print("准备设置")
    a.array.countIsEqual(count: 10, append: {$0}, remove: {_ in })
    print("设置完成")
    
    print("准备设置")
    a.array.countIsEqual(count: 3, append: {$0}, remove: {_ in })
    print("设置完成")
}
class TestArr {
    var array: [Int] = [] {
        didSet {
            print(self.array)
        }
    }
}
