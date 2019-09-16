//
//  CountdownButton.swift
//  TJS
//
//  Created by 苏义坤 on 2018/5/14.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public class CountdownButton: Button {
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.timer.suspend()
            } else {
                self.update(self.timer.originalTimes)
                self.timer.reCountDown()
                self.timer.start()
            }
        }
    }

    public var updateDisabledText: ((Int) -> (String))?
    /// ZJaDe: 默认设置的倒计时总时间，设置后需要手动更新
    public var totalSeconds: Int = 60
    /// ZJaDe: 有时候会根据实际情况得出实际的总倒计时时间，设置为nil则用默认的totalSeconds
    public var realTempTotalSeconds: Int? {
        get { self.timer.originalTimes }
        set { self.timer.originalTimes = newValue ?? self.totalSeconds }
    }
    lazy private(set) var timer: SwiftCountDownTimer = SwiftCountDownTimer(interval: .seconds(1), times: self.totalSeconds) {[weak self] (_, leftTimes) in
        self?.update(leftTimes)
    }
    func update(_ leftTimes: Int) {
        if let result = self.updateDisabledText?(leftTimes) {
            self.setTitle(result, for: .disabled)
        }
        if leftTimes == 0 {
            self.isEnabled = true
        }
    }
}
