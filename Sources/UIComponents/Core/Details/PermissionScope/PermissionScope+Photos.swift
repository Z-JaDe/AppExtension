//
//  PermissionScope+Photos.swift
//  Base
//
//  Created by ZJaDe on 2018/7/9.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import Photos
public extension PermissionScope {
    // ZJaDe: photos
    func requestPhotos(_ closure: @escaping PermissionScopeCallback) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Alert.showPrompt("相册不可用") { (_, _) in
                self.requestError(closure)
            }
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .restricted:
            self.requestError("app没有被授权访问相册, 可能是家长控制权限", closure)
        case .authorized, .limited:
            self.requestSuccessful(closure)
        case .denied:
            self.requestError("app被禁止访问相册", closure)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.requestSuccessful(closure)
                    } else {
                        self.requestError(closure)
                    }
                }
            }
        @unknown default:
            fatalError()
        }

    }
}
