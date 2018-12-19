//
//  PresentedCoordinator.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/12/19.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class PresentedCoordinator: Coordinator, CoordinatorContainer {
    public var coordinators: [Coordinator] = []
    public init() {}
}
