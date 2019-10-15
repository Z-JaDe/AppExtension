//
//  QRCode.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/11/3.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit

public class QRCode {
    /// ZJaDe: 生成高清二维码图片
    public static func image(qrString: String, imageSize: CGFloat, fillColor: UIColor = Color.darkBlack, backColor: UIColor = Color.white) -> UIImage? {
        guard qrString.isNotEmpty && imageSize > 10 else {
            return nil
        }
        let stringData = qrString.data(using: .utf8)
        /// ZJaDe: 生成
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")

        /// ZJaDe: 上色
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": qrFilter.outputImage!, "inputColor0": CIColor(cgColor: fillColor.cgColor), "inputColor1": CIColor(cgColor: backColor.cgColor)])!

        let qrImage = colorFilter.outputImage!

        /// ZJaDe: 绘制
        let imgSize = CGSize(width: imageSize, height: imageSize)
        let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent)!
        UIGraphicsBeginImageContext(imgSize)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .none
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return codeImage
    }
    /// ZJaDe: 从图片中读取二维码
    public static func scan(qrImage: UIImage) -> String? {
        let context = CIContext()
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let image = CIImage.init(cgImage: qrImage.cgImage!)
        let features = detector?.features(in: image)
        let feature = features?.first as? CIQRCodeFeature
        let result = feature?.messageString
        return result
    }
}
