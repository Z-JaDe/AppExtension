//
//  Step.swift
//  NavigationFlow
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

final class StepContext {
    public var fromChildFlow: Flow?
    weak var withinFlow: Flow?

    let step: Step
    init(with step: Step) {
        self.step = step
    }
    static var none: StepContext {
        StepContext(with: NoneStep())
    }
}

public protocol Step {}
struct NoneStep: Step {}
