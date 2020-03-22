//
//  ResultHandleProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/9/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxNetwork
import Alamofire

public protocol ResultHandleProtocol {
    func handleResult(_ showHUD: ShowNetworkHUD)
}
extension Observable where Element: ResultHandleProtocol {
    public func showHUDWhenComplete(_ showHUD: ShowNetworkHUD) -> Observable<Element> {
        `do`(afterNext: { (element) in
            element.handleResult(showHUD)
        }, afterError: { (error) in
            showHUD.showResultError(error)
        })
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait, Element: ResultHandleProtocol {
    public func showHUDWhenComplete(_ showHUD: ShowNetworkHUD) -> Single<Element> {
        `do`(afterSuccess: { (element) in
            element.handleResult(showHUD)
        }, afterError: { (error) in
            showHUD.showResultError(error)
        })
    }
}
// MARK: -
extension ObservableType where Element: RNDataResponseCompatible, Element.Success: ResultModelType {
    public func ignoreErrorCodes(_ resultTypes: [ResultCode]) -> Observable<DataResponse<Element.Success, Error>> {
        map { (response) -> DataResponse<Element.Success, Error> in
            return response.tryMap { (resultModel) -> Element.Success in
                if resultTypes.contains(resultModel.resultCode) {
                    throw NetworkError.ignore
                }
                return resultModel
            }
        }
    }
}
extension ObservableType where Element: RNDownloadResponseCompatible, Element.Success: ResultModelType {
    public func ignoreErrorCodes(_ resultTypes: [ResultCode]) -> Observable<DownloadResponse<Element.Success, Error>> {
        map { (response) -> DownloadResponse<Element.Success, Error> in
            return response.tryMap { (resultModel) -> Element.Success in
                if resultTypes.contains(resultModel.resultCode) {
                    throw NetworkError.ignore
                }
                return resultModel
            }
        }
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait, Element: RNDataResponseCompatible, Element.Success: ResultModelType {
    public func ignoreErrorCodes(_ resultTypes: [ResultCode]) -> Single<DataResponse<Element.Success, Error>> {
        map { (response) -> DataResponse<Element.Success, Error> in
            return response.tryMap { (resultModel) -> Element.Success in
                if resultTypes.contains(resultModel.resultCode) {
                    throw NetworkError.ignore
                }
                return resultModel
            }
        }
    }
}
extension PrimitiveSequenceType where Trait == SingleTrait, Element: RNDownloadResponseCompatible, Element.Success: ResultModelType {
    public func ignoreErrorCodes(_ resultTypes: [ResultCode]) -> Single<DownloadResponse<Element.Success, Error>> {
        map { (response) -> DownloadResponse<Element.Success, Error> in
            return response.tryMap { (resultModel) -> Element.Success in
                if resultTypes.contains(resultModel.resultCode) {
                    throw NetworkError.ignore
                }
                return resultModel
            }
        }
    }
}
