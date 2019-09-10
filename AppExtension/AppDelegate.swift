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
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
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
        print("AAA".failureDebugColor())
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
extension String {
    public func failureDebugColor() -> String {
        return Array(self).map({"\($0)\u{0001f3fb}"}).joined()
    }
    
    public func successDebugColor() -> String {
        return debugColor("\u{0001f3fc}")
    }
    
    public func warningDebugColor() -> String {
        return debugColor("\u{0001f3fd}")
    }
    
    public func debugColor(_ colorStr: String) -> String {
        return map({"\($0)\(colorStr)"}).joined()
    }
}
class Foo {
    dynamic func bar() {
        print("--")
    }
}
extension Foo {
    @_dynamicReplacement(for: bar)
    func barA() {
        print("A")
        bar()
    }
}


extension Foo {
    @_dynamicReplacement(for: bar)
    func barB() {
        print("B")
        bar()
    }
}
