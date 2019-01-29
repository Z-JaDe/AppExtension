//
//  ImagePickerController.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/12/27.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit
import MobileCoreServices

open class ImagePickerController: UIImagePickerController {
    open var callBack: (UIImage) -> Void = { (image) in
        logDebug("回调没有写")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.allowsEditing = true
    }
}
extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let type = info[.mediaType] as? String, type == kUTTypeImage as String else {
            HUD.showError("您选择的不是图片")
            self.dismissVC()
            return
        }
        if let image = info[.editedImage] as? UIImage {
            self.callBack(image)
        } else {
            HUD.showError("您选择的图片的格式有问题，您可以重新尝试，或换张图片")
        }
        self.dismissVC()
    }
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismissVC()
    }
}
