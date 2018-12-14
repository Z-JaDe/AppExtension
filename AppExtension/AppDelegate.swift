//
//  AppDelegate.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import RxSwift
import Async
import Core
import Codable
import Animater
import RouterManager
import AnimatedTransition
import UserNotificationManager
import RxExtensions
import UIComponents
import EmptyDataSet
import ProjectBasic
import List

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window?.backgroundColor = UIColor.white
        return true
    }

    func hasher() {
        var hasher = Hasher()
        hasher.combine(UIControl.State.highlighted.rawValue)
        print(hasher.finalize())
        print(UIControl.State.highlighted.rawValue.hashValue)
        print("1".hashValue)
    }

    func mainColor() {
        DispatchQueue.main.async {
            var image:UIImage?

            let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
            view.backgroundColor = UIImage(named: "bank_abc")?.mainColor()
            self.window?.addSubview(view)
            var _image:UIColor?
            logTimer {
                _image = UIImage(named: "bank_abc")?.mainColor()
            }
            logDebug(_image)

            let imageView = UIImageView(image: image)
            imageView.left = view.right
            imageView.top = view.top
            self.window?.addSubview(imageView)
        }
    }
    func flatMapLatest() {
        let publish = PublishSubject<Int>()
        let publishFlat = publish.logDebug("a").flatMapLatest { (value) in
            return Observable.just(value)
            }.share()
        
        publishFlat.subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: self.disposeBag)
        publishFlat.subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: self.disposeBag)
        publishFlat.subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: self.disposeBag)
        publishFlat.subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: self.disposeBag)
        publishFlat.subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: self.disposeBag)
        publish.onNext(1)
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
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

class AAA:DisposeBagProtocol {
    let button = Button()
    init() {
        defer {
            self.configInit()
            print("AAA")
        }
    }
    lazy var a: () -> Void = { [self] in
        print(self)
    }
    func configInit() {
        let a = [1,2,3,4,5,6].lazy.compactMap { (value) -> Int? in
            print("处理\(value)")
            if value < 3 {
                return nil
            }
            return value
            }.map{$0 + 1}.first
        print("a打印之前")
        print(a)
    }
    deinit {
        print("A释放")
    }
}
class BBB: AAA {
    override init() {
        defer {
            print("BBBdefer")
        }
        super.init()
        print("BBB")
    }
    override func configInit() {
        super.configInit()
    }
    deinit {
        print("B释放")
    }
}
