//
//  PermissionScope.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/9.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public class PermissionScope: TaskProtocol {
    public var taskArr: [TaskItemType] = []

    public init() {}
    public typealias PermissionScopeCallback = (Bool) -> Void
    private var cancelTaskClosure: (() -> Void)?
    public func request(_ permission: Permission, _ callback: @escaping PermissionScopeCallback) {
        self.addAsyncTask({[weak self] (closure) in
            guard let `self` = self else { return }
            self.cancelTaskClosure = closure
            switch permission {
            case .camera:
                self.requestCamera(callback)
            case .microphone:
                self.requestMicrophone(callback)
            case .photos:
                self.requestPhotos(callback)
            }
        })
    }

    // ZJaDe: 
    internal func requestSuccessful(_ callback: PermissionScopeCallback) {
        callback(true)
        self.currentTaskComplete()
    }
    internal func requestError(_ callback: PermissionScopeCallback) {
        callback(false)
        self.currentTaskComplete()
    }
    internal func requestError(_ message: String, _ callback: @escaping PermissionScopeCallback) {
        Alert.showConfirm(message, { (_, _) in
            self.requestError(callback)
            self.openSettingUrl()
        }, { (_, _) in
            self.requestError(callback)
        })
    }
    internal func currentTaskComplete() {
        self.cancelTaskClosure?()
        self.cancelTaskClosure = nil
    }
    internal func openSettingUrl() {
        jd.openUrl(UIApplication.openSettingsURLString)
    }
}
