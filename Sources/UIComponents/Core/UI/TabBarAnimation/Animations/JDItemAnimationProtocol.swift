//  JDItemAnimationProtocol.swift
//
// Copyright (c) 11/10/14 Ramotion Inc. (http: //ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: 
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

protocol JDItemAnimationProtocol {

  func playAnimation(_ icon: UIImageView, textLabel: UILabel)
  func deselectAnimation(_ icon: UIImageView, textLabel: UILabel)
}

open class JDItemAnimation: NSObject, JDItemAnimationProtocol {

    struct AnimationKeys {
        static let Scale     = "transform.scale"
        static let Rotation    = "transform.rotation"
        static let KeyFrame  = "contents"
        static let PositionY = "position.y"
        static let Opacity   = "opacity"
    }

    var selectedImage: UIImage?

    @IBInspectable open var duration: CGFloat = 0.5

    open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        fatalError("override method in subclass")
    }

    open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
        fatalError("override method in subclass")
    }

    func playAlphaAnimation(_ view: UIView) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.Opacity)
        bounceAnimation.values = [1.0, 0.4, 0.2, 0.6, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        view.layer.add(bounceAnimation, forKey: nil)
    }

}
