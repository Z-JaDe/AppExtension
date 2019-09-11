//
//  MultipartFormData+Images.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Network
// MARK: -
extension Array where Element: UIImage {
    public func mapToFormData(name: String) -> [MultipartFormData] {
        var result = [MultipartFormData]()
        for (index, image) in self.enumerated() {
            if let data = UIImage.dataWithImage(image) {
                //                \(index)
                let formData = MultipartFormData(provider: .data(data), name: "\(name)[]", fileName: "\(index)\(String.random(min: 10, max: 16)).jpg", mimeType: "image/jpeg")
                result.append(formData)
            } else {
                logError("图片转换失败 -> (\(index))")
                HUD.showError("第\(index+1)张图片转换失败")
                continue
            }
        }
        return result
    }
}
