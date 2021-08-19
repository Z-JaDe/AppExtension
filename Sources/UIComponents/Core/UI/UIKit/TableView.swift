//
//  TableView.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class TableView: UITableView {

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
        self.backgroundColor = UIColor.clear
        
        if self.style == .grouped && self.tableHeaderView == nil {
            let view = UIView()
            view.height = 0.1
            self.tableHeaderView = view
        }
    }

}
