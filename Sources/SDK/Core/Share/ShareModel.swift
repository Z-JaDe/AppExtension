//
//  ShareModel.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 17/3/21.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public class ShareModel: Codable {
    public init() {}
    public var shareId: String!

    public var title: String = ""
    public var content: String = ""
    public var icon: String = ""
    public var url: String = ""

    public var text: String {
        return "\(self.url)\n\(self.content)"
    }
}
