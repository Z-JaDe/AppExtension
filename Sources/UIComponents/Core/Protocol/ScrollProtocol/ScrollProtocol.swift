//
//  ScrollProtocol.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/12/14.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
// MARK: -
public protocol ScrollProtocol: Frameable {
    var contentInset: UIEdgeInsets {get set}
    var contentSize: CGSize {get set}
    var contentOffset: CGPoint {get set}
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool)

}
extension UIScrollView: ScrollProtocol {}
