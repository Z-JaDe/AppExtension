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
}
