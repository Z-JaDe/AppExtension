import UIKit
open class FumeAnimation: ItemAnimation {

    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playMoveIconAnimation(icon, values: [icon.center.y, icon.center.y + 4.0])
        playLabelAnimation(textLabel)
    }

    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playMoveIconAnimation(icon, values: [icon.center.y + 4.0, icon.center.y])
        playDeselectLabelAnimation(textLabel)
    }

    // MARK: -
    func playMoveIconAnimation(_ icon: UIImageView, values: [CGFloat]) {

        let yPositionAnimation = createAnimation(AnimationKeys.PositionY, values: values, duration: duration / 2)
        icon.layer.add(yPositionAnimation, forKey: nil)
    }
    // MARK: - LabelAnimation
    func playLabelAnimation(_ textLabel: UILabel) {
        let yPositionAnimation = createAnimation(AnimationKeys.PositionY, values: [textLabel.center.y, textLabel.center.y - 60.0], duration: duration)
        yPositionAnimation.fillMode = CAMediaTimingFillMode.removed
        yPositionAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(yPositionAnimation, forKey: nil)

        let scaleAnimation = createAnimation(AnimationKeys.Scale, values: [1.0, 2.0], duration: duration)
        scaleAnimation.fillMode = CAMediaTimingFillMode.removed
        scaleAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(scaleAnimation, forKey: nil)

        let opacityAnimation = createAnimation(AnimationKeys.Opacity, values: [1.0, 0.0], duration: duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }

    // MARK: deselect animation
    func playDeselectLabelAnimation(_ textLabel: UILabel) {
        let yPositionAnimation = createAnimation(AnimationKeys.PositionY, values: [textLabel.center.y + 15, textLabel.center.y], duration: duration)
        textLabel.layer.add(yPositionAnimation, forKey: nil)

        let opacityAnimation = createAnimation(AnimationKeys.Opacity, values: [0, 1], duration: duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }

    // MARK: - createAnimation
    func createAnimation(_ keyPath: String, values: [CGFloat], duration: CGFloat) -> CAKeyframeAnimation {

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        animation.duration = TimeInterval(duration)
        animation.calculationMode = CAAnimationCalculationMode.cubic
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        return animation
    }

}
