//
//  WebImage.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/9/5.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
#if canImport(Kingfisher) && canImport(Rx_Kingfisher) && canImport(RxSwift)
import Kingfisher
import Rx_Kingfisher
import RxSwift

extension UIImageView {
    @discardableResult
    public func setImage(_ imageData: ImageData?) -> RetrieveImageTask? {
        return self.kf.setImage(imageData)
    }
}

extension Kingfisher where Base: ChainCompatible,
    Base.ChainType: ViewChain<UIImageView> {
    func checkPlaceholder(_ chain: Base.ChainType) -> Kingfisher<Base.ChainType> {
        if chain.placeholder == nil {
            return placeholder(ImageData.default)
        } else {
            return base.chain().kf
        }
    }
    @discardableResult
    public func setImage(_ imageData: ImageData?) -> RetrieveImageTask? {
        let kingfisher = checkPlaceholder(base.chain())
        let chain = kingfisher.base.chain()
        switch imageData {
        case .image(let image)?:
            let view = chain.view
            view.image = image
            return nil
        case .url(let url)?:
            return kingfisher.setImage(url?.url)
        case .none:
            return nil
        }
    }
    @discardableResult
    public func setImage(with imageData: ImageData?) -> Observable<ImageViewTupleType> {
        let kingfisher = checkPlaceholder(base.chain())
        let chain = kingfisher.base.chain()
        switch imageData {
        case .image(let image)?:
            let view = chain.view
            view.image = image
            return Observable.just((view, image))
        case .url(let url)?:
            return kingfisher.setImage(with: url?.url)
        case .none:
            return Observable.empty()
        }
    }
}
// MARK: -
extension UIButton {
    @discardableResult
    public func setImage(_ imageData: ImageData?, for state: UIControl.State) -> RetrieveImageTask? {
        return self.kf.setImage(imageData, for: state)
    }
}
extension Kingfisher where Base: ChainCompatible,
    Base.ChainType: ViewChain<UIButton> {
    func checkPlaceholder(_ chain: Base.ChainType) -> Kingfisher<Base.ChainType> {
        if chain.placeholder == nil {
            return placeholder(ImageData.default)
        } else {
            return base.chain().kf
        }
    }
    @discardableResult
    public func setImage(_ imageData: ImageData?, for state: UIControl.State) -> RetrieveImageTask? {
        let kingfisher = checkPlaceholder(base.chain())
        let chain = kingfisher.base.chain()
        switch imageData {
        case .image(let image)?:
            let view = chain.view
            view.setImage(image, for: state)
            return nil
        case .url(let url)?:
            return kingfisher.setImage(url?.url, for: state)
        case .none:
            return nil
        }
    }
    public func setImage(with imageData: ImageData?, for state: UIControl.State) -> Observable<ButtonTupleType> {
        let kingfisher = checkPlaceholder(base.chain())
        let chain = kingfisher.base.chain()
        switch imageData {
        case .image(let image)?:
            let view = chain.view
            view.setImage(image, for: state)
            return Observable.just((view, image, state))
        case .url(let url)?:
            return kingfisher.setImage(with: url?.url, for: state)
        case .none:
            return Observable.empty()
        }
    }
}

//extension ImageData {
//    var resource: ImageResource? {
//        switch self {
//        case .image(_): 
//            return nil
//        case .url(let url): 
//            if let url = url?.url {
//                return ImageResource(downloadURL: url)
//            } else {
//                return nil
//            }
//        }
//    }
//}
#endif
