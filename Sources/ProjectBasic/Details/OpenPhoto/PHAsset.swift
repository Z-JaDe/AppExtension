//
//  PHAsset.swift
//  Extension
//
//  Created by 茶古电子商务 on 2018/4/19.
//  Copyright © 2018年 Z_JaDe. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    public var isHEIF: Bool {
        var isHEIF: Bool = false
        let resourceList = PHAssetResource.assetResources(for: self)
        for resource in resourceList {
            let UTI = resource.uniformTypeIdentifier
            if isHEIFWithUTI(UTI) {
                isHEIF = true
                break
            }
        }
        return isHEIF
    }
    private func isHEIFWithUTI(_ UTI: String) -> Bool {
        UTI == "public.heif" || UTI == "public.heic"
    }
    // MARK: -
    public func requestImageData(_ callback: @escaping (Data?) -> Void) {
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImageData(for: self, options: options, resultHandler: { (data, _, _, _) in
            Async.background { () -> Data? in
                var data: Data? = data
                if let tempData = data, self.isHEIF {
                    if #available(iOS 10, *) {
                        if let ciImage = CIImage(data: tempData) {
                            let context = CIContext()
                            data = context.jpegRepresentation(of: ciImage, colorSpace: ciImage.colorSpace!, options: [: ])
                        }
                    }
                }
                return data
            }.main(callback)
        })
    }
    // MARK: -
    public func requestImage(_ targetSize: CGSize? = nil, _ callback: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        let targetSize = adapterSize(targetSize)
        PHImageManager.default().requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
            callback(image)
        }
    }
}
extension PHAsset {
    func adapterSize(_ targetSize: CGSize?) -> CGSize {
        var width = CGFloat(self.pixelWidth)
        var height = CGFloat(self.pixelHeight)
        let maxWidth: CGFloat = 3000
        if width > maxWidth {
            height = height / width * maxWidth
            width = maxWidth
        }
        let maxHeight: CGFloat = 3000
        if height > maxHeight {
            width = width / height * maxHeight
            height = maxHeight
        }
        return targetSize ?? CGSize(width: width, height: height)
    }
}
