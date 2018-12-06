////
////  ListViewControllerTest.swift
////  AppExtension
////
////  Created by 郑军铎 on 2018/8/27.
////  Copyright © 2018年 ZJaDe. All rights reserved.
////
//
//import Foundation
//
//class ListViewControllerTest: NavItemTableViewController, ListDelegateProtocol {
//    var cells: [StaticTableItemCell] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.listVC.adapter.delegate = self
//        reload()
//    }
//    let tableSection = TableSection()
//    func reload() {
//        if self.cells.count > 5 {
//            self.cells.removeLast()
//        } else {
//            self.cells.append(DetailTitleCell(title: "\(self.cells.count)", detailText: " "))
//        }
//        self.listVC.adapter.reloadData { () -> [(TableSection, [StaticTableItemCell])]? in
//            return [(self.tableSection, self.cells)]
//        }
//    }
//    func didSelectItem(at indexPath: IndexPath) {
//        self.reload()
//    }
//}
