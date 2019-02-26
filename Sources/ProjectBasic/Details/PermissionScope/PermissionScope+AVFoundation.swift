//
//  PermissionScope+CaptureDevice.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/9.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import AVFoundation

public extension PermissionScope {
    // ZJaDe: camera
    func requestCamera(_ closure: @escaping PermissionScopeCallback) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            Alert.showPrompt("照相机不可用") { (_, _) in
                self.requestError(closure)
            }
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .restricted:
            self.requestError("app没有被授权访问照相机, 可能是家长控制权限", closure)
        case .authorized:
            self.requestSuccessful(closure)
        case .denied:
            self.requestError("app被禁止访问照相机", closure)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (isSuccessful) in
                if isSuccessful {
                    self.requestSuccessful(closure)
                } else {
                    self.requestError(closure)
                }
            }
        }
    }

    // ZJaDe: microphone
    func requestMicrophone(_ closure: @escaping PermissionScopeCallback) {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .restricted:
            self.requestError("app没有被授权访问麦克风, 可能是家长控制权限", closure)
        case .authorized:
            self.requestSuccessful(closure)
        case .denied:
            self.requestError("app被禁止访问麦克风", closure)
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
                Async.main {
                    if granted {
                        self.requestSuccessful(closure)
                    } else {
                        self.requestError(closure)
                    }
                }
            }
        }
    }
}
