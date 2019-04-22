//
//  WebImage.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/9/5.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
#if canImport(Kingfisher) && canImport(RxSwift)
import Kingfisher
import RxSwift

extension UIImageView {
    @discardableResult
    public func setImage(_ imageData: ImageData?,
                         placeholder: Placeholder? = ImageData.default,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask? {
        switch imageData {
        case .url(let url)?:
            return self.kf.setImage(with: url?.url, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .image(let image)?:
            self.image = image
            return nil
        case .none:
            return nil
        }
    }
}

// MARK: -
extension UIButton {
    @discardableResult
    public func setImage(_ imageData: ImageData?,
                         for state: UIControl.State,
                         placeholder: UIImage? = ImageData.default,
                         options: KingfisherOptionsInfo? = nil,
                         progressBlock: DownloadProgressBlock? = nil,
                         completionHandler: CompletionHandler? = nil) -> RetrieveImageTask? {
        switch imageData {
        case .url(let url)?:
            return self.kf.setImage(with: url?.url, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .image(let image)?:
            self.setImage(image, for: state)
            return nil
        case .none:
            return nil
        }
    }
}

#endif
