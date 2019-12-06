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
        guard !qrString.isEmpty && imageSize > 10 else { return nil }
        let stringData = qrString.data(using: .utf8)
        /// ZJaDe: 生成
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        guard let outputImage = qrFilter.outputImage else { return nil }
        /// ZJaDe: 上色
        guard let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": outputImage, "inputColor0": fillColor.ciColor, "inputColor1": backColor.ciColor]) else { return nil }

        guard let qrImage = colorFilter.outputImage else { return nil }

        /// ZJaDe: 绘制
        let imgSize = CGSize(width: imageSize, height: imageSize)
        guard let cgImage = CIContext().createCGImage(qrImage, from: qrImage.extent) else { return nil }
        UIGraphicsBeginImageContext(imgSize)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .none
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return codeImage
    }
    /// ZJaDe: 从图片中读取二维码
    public static func scan(qrImage: UIImage) -> String? {
        guard let ciImage = qrImage.ciImage else { return nil }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: CIContext(), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        return ((detector?.features(in: ciImage))?.first as? CIQRCodeFeature)?.messageString
    }
}
