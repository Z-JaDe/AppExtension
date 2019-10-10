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
        #if DEBUG
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        // Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection10.bundle")?.load()
        // Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/tvOSInjection10.bundle")?.load()
        #endif
        self.window?.backgroundColor = UIColor.white
//        let result = "6226095711104732".isValidBankCard
//        logDebug(result)
//        swiftTest()
//        lockTest()
//        gcdTest()
//        copyTest()
        Foo().bar()
        Observable<Int>.create { (observer) -> Disposable in
            observer.onNext(1)
//            observer.onNext(2)
            return Disposables.create()
        }.debug("外").flatMapLatest { (_) -> Observable<Int> in
            Observable.create { (observer) -> Disposable in
                observer.onNext(11)
                observer.onError(NetworkError.ignore)
                return Disposables.create()
                }.debug("内")
        }.catchErrorJustComplete()
        .debug("结束")
        .subscribeOnNext { (_) in
            
            }.disposed(by: self.disposeBag)
        return true
    }

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

class Foo {
    dynamic func bar() {
        print("--")
    }
}
//extension Foo {
//    @_dynamicReplacement(for: bar)
//    func barA() {
//        print("A")
//        bar()
//    }
//}


//extension Foo {
//    @_dynamicReplacement(for: bar)
//    func barB() {
//        print("B")
//        bar()
//    }
//}
