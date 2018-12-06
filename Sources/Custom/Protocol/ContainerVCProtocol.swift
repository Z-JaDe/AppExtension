//
//  ContainerVCProtocol.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/11/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol ContainerItemVCProtocol {
    var itemView: UIView {get}
    var viewCon: UIViewController {get}

}
extension ContainerItemVCProtocol where Self: UIViewController {
    public var itemView: UIView {
        return self.view
    }
    public var viewCon: UIViewController {
        return self
    }
}

public protocol ContainerVCProtocol: class {
//    associatedtype ItemVCType: ContainerItemVCProtocol, Equatable
//    var currentVC: ItemVCType? {get set}
//    var dataArray: [ItemTitleType: ItemVCType] {get set}
    func changeCurrentVC(_ toIndex: Int)
}
