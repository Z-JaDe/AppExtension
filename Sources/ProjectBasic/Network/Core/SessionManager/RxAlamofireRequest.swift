//
//  RxAlamofireResponse.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol RxAlamofireRequest {
    func resume()
    func cancel()
}
extension DataRequest: RxAlamofireRequest {}
extension DownloadRequest: RxAlamofireRequest {}
