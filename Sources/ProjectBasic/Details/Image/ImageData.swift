//
//  ImageData.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public enum ImageData: Codable {
    case image(UIImage?)
    case url(ImageURLProtocol?)

    public var urlData: String? {
        switch self {
        case .url(let imageData):
            return imageData?.url?.absoluteString
        case .image:
            return nil
        }
    }
    public var image: UIImage? {
        switch self {
        case .url:
            return nil
        case .image(let image):
            return image
        }
    }
    // MARK: - Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let url = self.urlData {
            try container.encode(url)
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = container.decodeString() {
            if value.hasPrefix("ic_") {
                self = .image(UIImage(named: value, in: Bundle.main, compatibleWith: nil))
            } else {
                self = .url(value)
            }
        } else if let value = try? container.decode(URL.self) {
            self = .url(value)
        } else if let value = try? container.decode(String.self) {
            self = .url(value)
        } else {
            self = .url(nil)
        }
    }
}
extension ImageData: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .url(value)
    }
}
