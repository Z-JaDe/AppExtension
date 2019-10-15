//
//  Animater.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/15.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

/** ZJaDe: 
 这个framework会封装或者添加一些动画，界面跳转动画
 */

public enum ShakeDirection {
    case horizontal
    case vertical
}

import Foundation
import UIKit
public class Animater {
    public static var defaultDuration: TimeInterval = 0.25
    public init() {}
    // MARK: - duration
    var duration: TimeInterval = Animater.defaultDuration
    public func duration(_ duration: TimeInterval?) -> Animater {
        self.duration = duration ?? 0.25
        return self
    }
    // MARK: - delay
    var delay: TimeInterval = 0.00
    public func delay(_ delay: TimeInterval) -> Animater {
        self.delay = delay
        return self
    }
    // MARK: - options
    var options: UIView.AnimationOptions?
    public func options(_ options: UIView.AnimationOptions) -> Animater {
        self.options = options
        return self
    }
    // MARK: - animationsClosure
    public typealias AnimationsClosureType = () -> Void
    var animationsClosure: AnimationsClosureType?
    public func animations(_ animationsClosure: @escaping AnimationsClosureType) -> Animater {
        self.animationsClosure = animationsClosure
        return self
    }
    // MARK: - completionClosure
    public typealias CompletionClosureType = (Bool) -> Void
    var completionClosure: CompletionClosureType?
    public func completion(_ completionClosure: @escaping CompletionClosureType) -> Animater {
        self.completionClosure = completionClosure
        return self
    }
}
