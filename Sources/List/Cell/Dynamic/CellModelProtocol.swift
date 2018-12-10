//
//  CellModelProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public protocol CellModelProtocol: ConfigModelProtocol, ModelUpdateProtocol {
    init(model: ModelType)
}
public protocol ModelUpdateProtocol {
    var modelUpdateTask: NeedUpdateTask {get}
}
