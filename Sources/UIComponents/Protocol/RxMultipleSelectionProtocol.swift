//
//  RxMultipleSelectionProtocol.swift
//  Extension
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//
#if canImport(RxSwift)
import Foundation
import RxSwift
public protocol RxMultipleSelectionProtocol: MultipleSelectionProtocol {
    var selectedItemArraySubject: PublishSubject<SelectedItemArrayType> {get}
}

extension RxMultipleSelectionProtocol where SelectItemType: SelectedStateDesignable {
    public func updateSelectState(_ item: SelectItemType, _ isSelected: Bool) {
        var item = item
        item.isSelected = isSelected
        self.selectedItemArraySubject.onNext(self.selectedItemArray)
        logDebug("\(self.selectedItemArray)")
    }
}
#endif
