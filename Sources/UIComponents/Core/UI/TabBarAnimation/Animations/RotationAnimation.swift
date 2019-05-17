import UIKit
import QuartzCore

open class RotationAnimation: ItemAnimation {

    public enum Direction {
        case left
        case right
    }

    open var direction: Direction!

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
        if direction != nil && direction == .left {
            toValue *= -1.0
        }

        rotateAnimation.toValue = toValue
        rotateAnimation.duration = TimeInterval(duration)

        icon.layer.add(rotateAnimation, forKey: nil)
    }
}

public class LeftRotationAnimation: RotationAnimation {
    public override init() {
        super.init()
        direction = .left
    }
}
public class RightRotationAnimation: RotationAnimation {
    public override init() {
        super.init()
        direction = .right
    }
}
