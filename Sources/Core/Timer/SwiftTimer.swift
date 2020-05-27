//
//  SwiftTimer.swift
//  SwiftTimer
//
//  Created by mangofang on 16/8/23.
//
//
import Foundation

public class SwiftTimer {

    private let internalTimer: DispatchSourceTimer

    public private(set) var isRunning = false

    public let repeats: Bool

    public typealias SwiftTimerHandler = (SwiftTimer) -> Void

    private var handler: SwiftTimerHandler

    public init(interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) {

        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let self = self {
                handler(self)
            }
        }

        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            internalTimer.schedule(deadline: .now() + interval)
        }
    }

    public static func repeaticTimer(interval: DispatchTimeInterval, queue: DispatchQueue = .main, handler: @escaping SwiftTimerHandler) -> SwiftTimer {
        SwiftTimer(interval: interval, repeats: true, queue: queue, handler: handler)
    }

    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }

    //You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }

    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }

    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }

    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }

    public func rescheduleHandler(handler: @escaping SwiftTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let self = self {
                handler(self)
            }
        }

    }
}

// MARK: Count Down
public class SwiftCountDownTimer {

    private let internalTimer: SwiftTimer

    private var leftTimes: Int

    public var originalTimes: Int

    private let handler: (SwiftCountDownTimer, _ leftTimes: Int) -> Void

    public init(interval: DispatchTimeInterval, times: Int, queue: DispatchQueue = .main, handler:  @escaping (SwiftCountDownTimer, _ leftTimes: Int) -> Void) {

        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = SwiftTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self]  _ in
            guard let self = self else { return }
            if self.leftTimes > 0 {
                self.leftTimes -= 1
                self.handler(self, self.leftTimes)
            } else {
                self.internalTimer.suspend()
            }
        }
    }

    public func start() {
        self.internalTimer.start()
    }
    public func fire() {
        self.internalTimer.fire()
    }
    public func suspend() {
        self.internalTimer.suspend()
    }

    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }

}

public extension DispatchTimeInterval {
    static func fromSeconds(_ seconds: Double) -> Self {
        .nanoseconds(Int(seconds * Double(NSEC_PER_SEC)))
    }
}
