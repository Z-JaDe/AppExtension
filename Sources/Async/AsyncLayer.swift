//
//  AsyncLayer.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/10.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

public class AsyncLayer: CALayer {
    private let sentinel: Sentinel = Sentinel()
    public var isDisplaysAsynchronously: Bool = true
    public var displayTask: AsyncLayerDisplayTask = AsyncLayerDisplayTask()

    open override class func defaultValue(forKey key: String) -> Any? {
        if key == "displaysAsynchronously" { return true}
        return super.defaultValue(forKey: key)
    }

    public override func setNeedsDisplay() {
        cancelAsyncDisplay()
        super.setNeedsDisplay()
    }
    public override func display() {
        super.contents = super.contents
        displayAsync()
    }
    deinit {
        cancelAsyncDisplay()
    }
}
extension AsyncLayer {
    private func displayAsync() {
        guard let displayClosure = displayTask.display else {
            willDisplay()
            self.contents = nil
            didDisplay(true)
            return
        }
        if self.isDisplaysAsynchronously {
            willDisplay()
            let value = sentinel.value
            let isCancelled = { return value != self.sentinel.value }
            DispatchQueue.global().async {
                self.displayAsync(displayClosure, isCancelled)
            }
        } else {
            cancelAsyncDisplay()
            self.displayAsync(displayClosure, {return false})
        }
    }
    private func displayAsync(_ displayClosure: AsyncLayerDisplayTask.DisplayClosure, _ isCancelled: @escaping () -> Bool) {
        let size = self.bounds.size
        let isOpaque = self.isOpaque
        let scale = self.contentsScale
        let backgroundColor: CGColor? = getBackgroundColor()

        guard size.width >= 1 && size.height >= 1 else {
            self.updateContentsInMain(nil, completion: {
                self.didDisplayInMain(true)
            })
            return
        }
        if isCancelled() { return self.didDisplayInMain(false) }
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.setBackgroundColor(backgroundColor, in: context)
        displayClosure(context, size, isCancelled)

        if isCancelled() {
            UIGraphicsEndImageContext()
            return self.didDisplayInMain(false)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if isCancelled() { return self.didDisplayInMain(false) }
        self.updateContentsInMain(image?.cgImage, completion: {
            if isCancelled() {
                return self.didDisplay(false)
            } else {
                self.didDisplay(true)
            }
        })
    }
}
extension AsyncLayer {
    private func getBackgroundColor() -> CGColor? {
        if isOpaque { return backgroundColor }
        return nil
    }
    private func setBackgroundColor(_ color: CGColor?, in context: CGContext) {
        let size = self.bounds.size
        let scale = self.contentsScale
        if isOpaque {
            context.saveGState()
            let color: CGColor = color.flatMap({$0.alpha < 1 ? nil : $0}) ?? UIColor.white.cgColor
            context.setFillColor(color)
            context.addRect(CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))
            context.fillPath()
            context.restoreGState()
        }
    }
    private func updateContentsInMain(_ contents: CGImage?, completion: @escaping () -> Void) {
        performInMain {
            self.contents = contents
            completion()
        }
    }
}
extension AsyncLayer {
    // MARK: -
    private func willDisplay() {
        self.displayTask.willDisplay?(self)
    }
    private func didDisplayInMain(_ isFinished: Bool) {
        performInMain {
            self.didDisplay(isFinished)
        }
    }
    private func performInMain(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    private func didDisplay(_ isFinished: Bool) {
        self.displayTask.didDisplay?(self, isFinished)
    }
    // MARK: -
    private func cancelAsyncDisplay() {
        sentinel.increase()
    }
}
// MARK: -
public class AsyncLayerDisplayTask {
    typealias DisplayClosure = (CGContext, CGSize, () -> Bool) -> Void
    public init() {}
    var willDisplay: ((CALayer) -> Void)?
    var display: DisplayClosure?
    var didDisplay: ((CALayer, Bool) -> Void)?
}
