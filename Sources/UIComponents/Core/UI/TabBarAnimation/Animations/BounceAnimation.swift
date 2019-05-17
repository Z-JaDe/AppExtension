import UIKit

open class BounceAnimation: ItemAnimation {
    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        playAlphaAnimation(textLabel)
    }
    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
    }

    func playBounceAnimation(_ icon: UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.Scale)
//        bounceAnimation.values = [1.0 , 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.values = [1.0, 1.2, 0.9, 1.07, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic

        icon.layer.add(bounceAnimation, forKey: nil)
  }
}
