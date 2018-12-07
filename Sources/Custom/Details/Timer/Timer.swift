//
//  Timer.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/5.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation

public typealias TimerExecuteClosure = (Timer?) -> Void

extension Timer {
    @discardableResult
    public class func timer(_ timeInterval: TimeInterval, repeats: Bool = true, _ closure: @escaping TimerExecuteClosure) -> Timer {
        let seconds: TimeInterval = max(timeInterval, 0.0001)
        let interval: CFAbsoluteTime = repeats ? seconds : 0
        let fireDate: CFAbsoluteTime = CFAbsoluteTimeGetCurrent() + seconds
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, closure)
        return timer!
    }
    @discardableResult
    public class func scheduleTimer(_ timeInterval: TimeInterval, repeats: Bool = true, _ closure: @escaping TimerExecuteClosure) -> Timer {
        let timer = Timer.timer(timeInterval, repeats: repeats, closure)
        RunLoop.current.add(timer, forMode: .default)
        return timer
    }
}
extension Timer {
    /// ZJaDe: 延时调用
    public static func performAfter(_ timeInterval: TimeInterval, after: @escaping () -> Void) {
        Timer.scheduleTimer(timeInterval, repeats: false) { (timer) in
            after()
            timer?.invalidate()
        }
    }
}
extension RunLoop {
    /// RunLoop beforeWaiting时调用
    ///
    /// - Parameter closure: 返回是否需要注销
    @discardableResult
    public func runWhenAfterWaiting(closure: @escaping (() -> (Bool))) -> CFRunLoopObserver? {
        let cfRunloop = self.getCFRunLoop()
        let runLoopMode: CFRunLoopMode = .defaultMode
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.afterWaiting.rawValue, true, 0) { (observer, _) in
            if closure() {
                CFRunLoopRemoveObserver(cfRunloop, observer, runLoopMode)
                return
            }
        }
        CFRunLoopAddObserver(cfRunloop, observer, runLoopMode)
        return observer
    }

    public func removeRunLoopObserver(observer: CFRunLoopObserver?) {
        guard let observer = observer else {
            return
        }
        let cfRunloop = self.getCFRunLoop()
        let runLoopMode: CFRunLoopMode = .defaultMode
        CFRunLoopRemoveObserver(cfRunloop, observer, runLoopMode)
    }
}
