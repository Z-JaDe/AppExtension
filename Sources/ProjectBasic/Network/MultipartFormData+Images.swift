//
//  MultipartFormData+Images.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
// MARK: -
extension Array where Element: UIImage {
    public func mapToFormData(name: String) -> MultipartFormData {
        let result = MultipartFormData()
        for (index, image) in self.enumerated() {
            if let data = UIImage.dataWithImage(image) {
                result.append(data, withName: "\(name)[]", fileName: "\(index)\(String.random(min: 10, max: 16)).jpg", mimeType: "image/jpeg")
            } else {
                logError("图片转换失败 -> (\(index))")
                HUD.showError("第\(index+1)张图片转换失败")
                continue
            }
        }
        return result
    }
}
