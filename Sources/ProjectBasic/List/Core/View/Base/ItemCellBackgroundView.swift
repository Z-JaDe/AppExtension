//
//  ItemCellBackgroundView.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public class ItemCellSelectedBackgroundView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

}
