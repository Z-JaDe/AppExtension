//
//  UserNotificationManager.swift
//  SNKit
//
//  Created by ZJaDe on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
#if !AppExtensionPods
@_exported import Core
#endif

public class UserNotificationManager: NSObject {
    public static let shared: UserNotificationManager = UserNotificationManager()

    public var tokenTask: ReplaySubject<String> = ReplaySubject.create(bufferSize: 1)

    public var didReceiveRemoteNotification: (([AnyHashable: Any], @escaping (UIBackgroundFetchResult) -> Void) -> Void)?

    public func register(_ application: UIApplication) {

        func registerForRemoteNotifications() {
            #if !TARGET_IPHONE_SIMULATOR
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            #endif
        }
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
                if granted {
                    logInfo("远程通知打开成功")
                    registerForRemoteNotifications()
                } else {
                    logInfo("远程通知打开失败")
                }
            }
        } else {
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
            registerForRemoteNotifications()
        }
    }

    // MARK: -
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var deviceTokenStr = (deviceToken as NSData).description
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: "<", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: ">", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: " ", with: "")
        logInfo("获取到deviceToken->\(deviceTokenStr)")
        self.tokenTask.onNext(deviceTokenStr)
    }
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logInfo("RegisterForRemoteNotificationsError->\(error)")
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logInfo("接收到远程消息->\(userInfo)")
        if let closure = self.didReceiveRemoteNotification {
            closure(userInfo, completionHandler)
        } else {
            completionHandler(.newData)
        }
    }

}
@available(iOS 10.0, *)
extension UserNotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
