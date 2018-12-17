//
//  FlowCoordinator.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

protocol FlowCoordinatorDelegate: class {
    func navigateToAnotherFlow(withParent parent: FlowItemCoordinator, withNextFlowItem nextFlowItem: NextFlowItem)

    func endFlowCoordinator(withIdentifier identifier: String)

    func willNavigate(to stepContext: StepContext)
    func didNavigate(to stepContext: StepContext)
}
class FlowItemCoordinator: DisposeBagProtocol {
    fileprivate var parent: FlowItemCoordinator?

    private let flow: Flow
    private let stepper: Stepper
    private let steps = PublishSubject<StepContext>()
    private weak var delegate: FlowCoordinatorDelegate!
    let identifier: String
    init(for flow: Flow,
         withStepper stepper: Stepper,
         withDelegate delegate: FlowCoordinatorDelegate,
         withParent parent: FlowItemCoordinator?) {
        self.flow = flow
        self.stepper = stepper
        self.delegate = delegate
        self.parent = parent
        self.identifier = "\(type(of: flow))-\(UUID().uuidString)"
    }

    func coordinate() {
        self.steps
            .do(onNext: { [unowned self] (stepContext) in
                self.delegate.willNavigate(to: stepContext)
            })
            .map { [unowned self] (stepContext) -> (StepContext, NextFlowItems) in
                return (stepContext, self.flow.navigate(to: stepContext.step))
            }.do(onNext: { [unowned self] (stepContext, _) in
                self.flow.flowReadySubject.onNext(true)
                stepContext.withinFlow = self.flow
                self.delegate.didNavigate(to: stepContext)
            }).map { [unowned self] (stepContext, nextFlowItems) -> (StepContext, [NextFlowItem]) in
                switch nextFlowItems {
                case .multiple(let flowItems):
                    return (stepContext, flowItems)
                case .one(let flowItem):
                    return (stepContext, [flowItem])
                case .end(let stepToSendToParentFlow):
                    if let parent = self.parent {
                        let stepContextForParentFlow = StepContext(with: stepToSendToParentFlow)
                        stepContextForParentFlow.fromChildFlow = self.flow
                        parent.steps.onNext(stepContextForParentFlow)
                    }
                    self.delegate.endFlowCoordinator(withIdentifier: self.identifier)
                    return (stepContext, [])
                case .triggerParentFlow(let stepToSendToParentFlow):
                    if let parent = self.parent {
                        let stepContextForParentFlow = StepContext(with: stepToSendToParentFlow)
                        stepContextForParentFlow.fromChildFlow = self.flow
                        parent.steps.onNext(stepContextForParentFlow)
                    }
                    return (stepContext, [])
                case .none:
                    return (stepContext, [])
                }
            }
            .flatMap { (arg) -> Observable<NextFlowItem> in
                return Observable.from(arg.1)
            }
            .do(onNext: { [unowned self] (nextFlowItem) in
                if nextFlowItem.nextPresentable is Flow {
                    self.delegate.navigateToAnotherFlow(withParent: self, withNextFlowItem: nextFlowItem)
                }
            })
            .filter { (nextFlowItem) -> Bool in
                return !(nextFlowItem.nextPresentable is Flow)
            }
            .flatMap { (nextFlowItem) -> Observable<Step> in
                let presentable = nextFlowItem.nextPresentable
                let stepper = nextFlowItem.nextStepper
                return stepper
                    .steps
                    .pausable(presentable.rxVisible)
            }
            .takeUntil(self.flow.rxDismissed.asObservable())
            .asDriver(onErrorJustReturn: NoneStep()).drive(onNext: { [weak self] (step) in
                let newStepContext = StepContext(with: step)
                self?.steps.onNext(newStepContext)
            }).disposed(by: flow.disposeBag)

        // ZJaDe: stepper接受到新的信号后，开启新的StepContext
        self.stepper
            .steps
            .pausableBuffered(self.flow.rxVisible)
            .asDriver(onErrorJustReturn: NoneStep())
            .drive(onNext: { [weak self] (step) in
                guard let `self` = self else { return }
                let newStepContext = StepContext(with: step)
                newStepContext.withinFlow = self.flow
                self.steps.onNext(newStepContext)
            }).disposed(by: flow.disposeBag)
        // ZJaDe: 界面消失后 结束流
        self.flow.rxDismissed.subscribe(onSuccess: { [weak self] in
            guard let `self` = self else { return }
            self.delegate.endFlowCoordinator(withIdentifier: self.identifier)
        }).disposed(by: flow.disposeBag)
    }
}
public final class FlowCoordinator: DisposeBagProtocol, Synchronizable {
    private var flowCoordinators = [String: FlowItemCoordinator]()
    fileprivate let willNavigateSubject = PublishSubject<(Flow, Step)>()
    fileprivate let didNavigateSubject = PublishSubject<(Flow, Step)>()

    public init() {}

    public func coordinate(flow: Flow, withStepper stepper: Stepper) {
        self.coordinate(flow: flow, withStepper: stepper, withParent: nil)
    }

    internal func coordinate(flow: Flow, withStepper stepper: Stepper, withParent parent: FlowItemCoordinator?) {
        let flowItem = FlowItemCoordinator(for: flow, withStepper: stepper, withDelegate: self, withParent: parent)
        if let parent = parent {
            flowItem.parent = parent
        }
        synchronized { [unowned self] in
            self.flowCoordinators[flowItem.identifier] = flowItem
        }
        flowItem.coordinate()
    }
}
extension FlowCoordinator: FlowCoordinatorDelegate {
    func navigateToAnotherFlow(withParent parent: FlowItemCoordinator, withNextFlowItem nextFlowItem: NextFlowItem) {
        if let nextFlow = nextFlowItem.nextPresentable as? Flow {
            self.coordinate(flow: nextFlow, withStepper: nextFlowItem.nextStepper, withParent: parent)
        }
    }
    func endFlowCoordinator(withIdentifier identifier: String) {
        _ = synchronized { [unowned self] in
            self.flowCoordinators.removeValue(forKey: identifier)
        }
    }

    func willNavigate(to stepContext: StepContext) {
        if let withinFlow = stepContext.withinFlow {
            self.willNavigateSubject.onNext((withinFlow, stepContext.step))
        }
    }
    func didNavigate(to stepContext: StepContext) {
        if let withinFlow = stepContext.withinFlow {
            self.didNavigateSubject.onNext((withinFlow, stepContext.step))
        }
    }
}

extension FlowCoordinator {
    public var rx: Reactive<FlowCoordinator> {
        return Reactive(self)
    }
}
extension Reactive where Base: FlowCoordinator {
    public var willNavigate: Observable<(Flow, Step)> {
        return self.base.willNavigateSubject.asObservable()
    }
    public var didNavigate: Observable<(Flow, Step)> {
        return self.base.didNavigateSubject.asObservable()
    }
}
