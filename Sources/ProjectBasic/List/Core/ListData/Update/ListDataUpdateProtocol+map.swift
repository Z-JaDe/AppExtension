//
//  ListDataUpdateProtocol+SectionModel.swift
//  List
//
//  Created by 郑军铎 on 2018/6/8.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift

extension ListDataUpdateProtocol {
    /// 转成(组, model)类型信号
    /// 将ListDataType转换为SectionModelType
    static func compactMap<Section, Item>(_ data: ListData<Section, Item>.Element) -> SectionModelItem<Section, Item>? {
        if let section = data.section as? HiddenStateDesignable, section.isHidden {
            return nil
        }
        let items = data.items.filter({ (item) -> Bool in
            if let item = item as? HiddenStateDesignable {
                return item.isHidden != true
            } else {
                return true
            }
        })
        if items.count <= 0 {
            return nil
        }
        return SectionModelItem(data.0, items)
    }
}
