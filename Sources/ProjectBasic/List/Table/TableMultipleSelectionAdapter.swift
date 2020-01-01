//
//  MultipleSelectionAdapter.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/12/28.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public class TableMultipleSelectionAdapter: MultipleSelectionProtocol {
    public weak var listAdapter: UITableAdapter?
    init(_ listAdapter: UITableAdapter) {
        self.listAdapter = listAdapter
        listAdapter.
    }
    
}
