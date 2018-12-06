import UIKit
import QuartzCore

open class JDRotationAnimation: JDItemAnimation {

    public enum JDRotationDirection {
        case left
        case right
    }

    open var direction: JDRotationDirection!

    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playRoatationAnimation(icon)
        playAlphaAnimation(textLabel)
    }

    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {

    }

    func playRoatationAnimation(_ icon: UIImageView) {

        let rotateAnimation = CABasicAnimation(keyPath: AnimationKeys.Rotation)
        rotateAnimation.fromValue = 0.0

        var toValue: CGFloat = .pi * 2.0
        if direction != nil && direction == JDRotationDirection.left {
            toValue *= -1.0
        }

        rotateAnimation.toValue = toValue
        rotateAnimation.duration = TimeInterval(duration)

        icon.layer.add(rotateAnimation, forKey: nil)
    }
}

public class JDLeftRotationAnimation: JDRotationAnimation {
    public override init() {
        super.init()
        direction = JDRotationDirection.left
    }
}
public class JDRightRotationAnimation: JDRotationAnimation {
    public override init() {
        super.init()
        direction = JDRotationDirection.right
    }
}
