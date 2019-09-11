//
//  ListResult.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/10.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol ListResultModelType: Codable {
    associatedtype Item: Codable
    var list: [Item] {get set}
    var count: Count? {get}
}
public class ListResultModel<ListItem: Codable>: Codable, ListResultModelType {
    public var count: Count?
    public var list: [ListItem] = []
    public init() {}
}
