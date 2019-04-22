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
    public func setImage(
        _ imageData: ImageData?,
        placeholder: Placeholder? = ImageData.default,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        switch imageData {
        case .url(let url)?:
            return self.kf.setImage(with: url?.url, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .image(let image)?:
            return self.kf.setImage(with: image?.kfDataProvider, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .none:
            return nil
        }
    }
}

// MARK: -
extension UIButton {
    @discardableResult
    public func setImage(
        _ imageData: ImageData?,
        for state: UIControl.State,
        placeholder: UIImage? = ImageData.default,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        switch imageData {
        case .url(let url)?:
            return self.kf.setImage(with: url?.url, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .image(let image)?:
            return self.kf.setImage(with: image?.kfSource, for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
        case .none:
            return nil
        }
    }
}
extension UIImage {
    public var kfDataProvider: RawImageDataProvider? {
        if let data = self.data() {
            return RawImageDataProvider(data: data, cacheKey: "")
        } else {
            return nil
        }
    }
    public var kfSource: Source? {
        if let dataProvider = self.kfDataProvider {
            return Source.provider(dataProvider)
        } else {
            return nil
        }
    }
}

#endif
