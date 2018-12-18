//
//  Stepper.swift
//  NavigationFlow
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol Stepper: AssociatedObjectProtocol {
    var steps: Observable<Step> { get }
}


public class OneStepper: Stepper {
    public init(withSingleStep singleStep: Step) {
        self.step.accept(singleStep)
    }
}
public final class CompositeStepper: Stepper {
    public private(set) var steps: Observable<Step>
    public init(steppers: [Stepper]) {
        let allSteps = steppers.map { $0.steps }
        self.steps = Observable.merge(allSteps)
    }
}

final class NoneStepper: OneStepper {
    convenience init() {
        self.init(withSingleStep: NoneStep())
    }
}
private var stepKey: UInt8 = 0
public extension Stepper {
    public var step: BehaviorRelay<Step> {
        return associatedObject(&stepKey, createIfNeed: BehaviorRelay<Step>(value: NoneStep()))
    }
    public var steps: Observable<Step> {
        return self.step.filter { !($0 is NoneStep) }
    }
}