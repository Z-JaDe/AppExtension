//
//  ImageURLProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/15.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol ImageURLProtocol {
    var url: URL? {get}
    var isEmpty: Bool {get}
}

extension String: ImageURLProtocol {
    public var url: URL? {
        URL(string: "\(self)")
    }
}
extension URL: ImageURLProtocol {
    public var url: URL? {
        self
    }
    public var isEmpty: Bool {
        self.absoluteString.isEmpty
    }
}
