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


// MARK: -
func hasher() {
    var hasher = Hasher()
    hasher.combine(UIControl.State.highlighted.rawValue)
    print(hasher.finalize())
    print(UIControl.State.highlighted.rawValue.hashValue)
    print("1".hashValue)
}

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
