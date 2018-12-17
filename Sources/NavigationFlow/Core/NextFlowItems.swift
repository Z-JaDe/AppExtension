//
//  NextFlowItems.swift
//  NavigationFlow
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct NextFlowItem {
    public let nextPresentable: Presentable
    public let nextStepper: Stepper
    public init(nextPresentable presentable: Presentable, nextStepper stepper: Stepper) {
        self.nextPresentable = presentable
        self.nextStepper = stepper
    }
}
public enum NextFlowItems {
    case multiple(flowItems: [NextFlowItem])
    case one(flowItem: NextFlowItem)
    case end(withStepForParentFlow: Step)
    case triggerParentFlow(withStep: Step)
    case none
}
