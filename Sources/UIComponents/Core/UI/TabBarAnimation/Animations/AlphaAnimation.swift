import UIKit

open class AlphaAnimation: ItemAnimation {

    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playAlphaAnimation(icon)
        playAlphaAnimation(textLabel)
    }
    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {

    }
}
