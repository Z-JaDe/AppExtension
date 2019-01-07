//
//  RxTests.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import XCTest
import RxSwift
import RxExtensions

class RxTests: XCTestCase {
    func testRx() {
        let pubSubject = PublishSubject<Int>()
        let pauser = PublishSubject<Bool>()

        pubSubject.withLatestFrom(pauser).subscribeOnNext { (value) in
            print(value)
        }.disposed(by: self.disposeBag)

        for index in 1...10 {
            pubSubject.onNext(index)
            if index == 1 {
                pauser.onNext(false)
            }
            if index == 5 {
                pauser.onNext(true)
            }
        }
    }
    func testCreate() {
        let observable = Observable<Int>.create { (obsever) -> Disposable in
            print("走了create闭包方法")
            obsever.onNext(1)
            obsever.onCompleted()
            return Disposables.create()
        }
        observable.subscribeOnNext { (value) in
            print(value)
        }.disposed(by: self.disposeBag)
        observable.subscribeOnNext { (value) in
            print(value)
        }.disposed(by: self.disposeBag)
    }
    func testShare() {
        var _observer: AnyObserver<Int>!
        let observable = Observable<Int>.create { (observer) -> Disposable in
            _observer = observer
            return Disposables.create()
        }.share()
        observable.subscribeOnNext {_ in}.disposed(by: disposeBag)
        subscribe(observable, observer: _observer)
    }
    func testFlatMapLatest() {
        let publish = PublishSubject<Int>()
        let publishFlat = publish.flatMapLatest { (value) -> Observable<Int> in
            print("走了flatMapLatest")
            return Observable.just(value)
        }//.share()
        subscribe(publishFlat, observer: publish)
    }
    func subscribe<T, O: ObserverType>(_ observable: Observable<T>, observer: O) where O.E == Int {
        observable.logDebug("a").subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: disposeBag)
        observable.logDebug("b").subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: disposeBag)
        observer.onNext(1)
        observable.logDebug("c").subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: disposeBag)
        observer.onCompleted()
        observer.onNext(1)
        observable.logDebug("d").subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: disposeBag)
        observable.logDebug("e").subscribeOnNext { (value) in
            logDebug(value)
            }.disposed(by: disposeBag)
        observer.onNext(1)
    }
    /** ZJaDe:
     subject2.multicast(subject1)
     multicast前后 subject2本身的订阅者并不受到影响。
     就算没有connect，subject1发射信号时，subject1和intSequence的订阅者都能接受到信号
     subject2发射的信号只有connect后才能被subject1和intSequence的订阅者接受
     其他用法
     multicast({subject1}, selector: {$0})
     和上面的相比相当于会自动connect，同时每次订阅都会创建一个ConnectableObservable。这种用法想不到哪里能用到，库里面只是定义并没有用到
     */
    func testMulticast() {
        let subject1 = PublishSubject<String>()
        subject1
            .subscribe(onNext: { print("Subject: \($0)") })
            .disposed(by: disposeBag)

        let subject2 = PublishSubject<String>()
//        let intSequence = subject2.multicast(subject1)

        let intSequence = subject2.multicast({subject1}, selector: {$0})
//        subject2.replay(1).asObservable().count()
        // 与下面相同：
//         .multicast(makeSubject: { () -> PublishSubject<Int> in
//            print("AAA")
//             return subject
//         })
        // ZJaDe: subject2本身的订阅不受影响
//        subject2
//            .subscribe(onNext: { print("Subject2: \($0)") })
//            .disposed(by: disposeBag)

        intSequence
            .subscribe(onNext: { print("\t Subscription 1:, Event: \($0)") })
            .disposed(by: disposeBag)

        subject1.onNext("1-->connect之前")
        subject2.onNext("2-->connect之前")
//        intSequence.connect().disposed(by: self.disposeBag)
//        subject1.onNext("1-->connect之后")
//        subject2.onNext("2-->connect之后")


        intSequence
            .subscribe(onNext: { print("\t Subscription 2:, Event: \($0)") })
            .disposed(by: self.disposeBag)
        subject1.onNext("1-->Subscription2之后")
        subject2.onNext("2-->Subscription2之后")
        intSequence
            .subscribe(onNext: { print("\t Subscription 3:, Event: \($0)") })
            .disposed(by: self.disposeBag)
        subject1.onNext("1-->Subscription3之后")
        subject2.onNext("2-->Subscription3之后")
    }
}
