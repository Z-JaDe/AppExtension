//
//  AsyncLayer.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/10.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

open class AsyncLayer: CALayer {
    private var sentinel: Sentinel = Sentinel()
    public var isDisplaysAsynchronously: Bool = true
    public var displayTask: AsyncLayerDisplayTask = AsyncLayerDisplayTask()

    open override class func defaultValue(forKey key: String) -> Any? {
        if key == "displaysAsynchronously" { return true }
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
            self.displayAsync(displayClosure, { false })
        }
    }
    private func displayAsync(_ displayClosure: AsyncLayerDisplayTask.DisplayClosure, _ isCancelled: @escaping () -> Bool) {
        let size = self.bounds.size
        let isOpaque = self.isOpaque
        let scale = self.contentsScale
        let backgroundColor: CGColor? = getBackgroundColor()

        guard size.width >= 1 && size.height >= 1 else {
            didDisplayAndUpdateContentsInMain(nil)
            return
        }
        if isCancelled() { return self.didDisplayInMain(false) }
        let format = UIGraphicsImageRendererFormat()
        format.opaque = isOpaque
        format.scale = scale
        let image = UIGraphicsImageRenderer(size: size, format: format).image { (context) in
            let context = context.cgContext
            self.setBackgroundColor(backgroundColor, in: context)
            displayClosure(context, size, isCancelled)
        }
        didDisplayAndUpdateContentsInMain(image.cgImage, isCancelled)
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
    private func didDisplayAndUpdateContentsInMain(_ contents: CGImage?, _ isCancelled: @escaping () -> Bool = { false }) {
        if isCancelled() {
            didDisplay(false)
        }
        performInMain {
            if isCancelled() {
                self.didDisplay(false)
            } else {
                self.contents = contents
                self.didDisplay(true)
            }
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
    private func performInMain(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            return action()
        } else {
            return DispatchQueue.main.async(execute: action)
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
public final class AsyncLayerDisplayTask {
    public typealias DisplayClosure = (CGContext, CGSize, () -> Bool) -> Void
    public init() {}
    public var willDisplay: ((CALayer) -> Void)?
    public var display: DisplayClosure?
    public var didDisplay: ((CALayer, Bool) -> Void)?
}
