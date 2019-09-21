//
//  MultipartFormData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
public struct MultipartFormData {
    public enum FormDataProvider {
        case data(Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }
    public let provider: FormDataProvider
    public let name: String
    public let fileName: String?
    public let mimeType: String?
    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
internal extension Alamofire.MultipartFormData {
    func append(data: Data, bodyPart: MultipartFormData) {
        if let mimeType = bodyPart.mimeType {
            if let fileName = bodyPart.fileName {
                append(data, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
            } else {
                append(data, withName: bodyPart.name, mimeType: mimeType)
            }
        } else {
            append(data, withName: bodyPart.name)
        }
    }
    func append(fileURL url: URL, bodyPart: MultipartFormData) {
        if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
            append(url, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
        } else {
            append(url, withName: bodyPart.name)
        }
    }
    func append(stream: InputStream, length: UInt64, bodyPart: MultipartFormData) {
        append(stream, withLength: length, name: bodyPart.name, fileName: bodyPart.fileName ?? "", mimeType: bodyPart.mimeType ?? "")
    }
    func applyMultipartFormData(_ multipartBody: [MultipartFormData]) {
        for bodyPart in multipartBody {
            switch bodyPart.provider {
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            case .file(let url):
                append(fileURL: url, bodyPart: bodyPart)
            case .stream(let stream, let length):
                append(stream: stream, length: length, bodyPart: bodyPart)
            }
        }
    }
}
