//
//  DefaultHeightProtocol.swift
//  Core
//
//  Created by ZJaDe on 2018/6/14.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public protocol DefaultHeightProtocol: AnyObject {
    var defaultHeight: CGFloat {get}
}
public protocol UpdateHeightProtocol {
    func update(viewHeight height: CGFloat)
}
public protocol WritableDefaultHeightProtocol: AnyObject {
    var defaultHeight: CGFloat {get set}
}
