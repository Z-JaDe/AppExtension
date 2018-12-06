import UIKit

open class JDAlphaAnimation: JDItemAnimation {

    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playAlphaAnimation(icon)
        playAlphaAnimation(textLabel)
    }
    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {

    }
}
