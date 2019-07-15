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
