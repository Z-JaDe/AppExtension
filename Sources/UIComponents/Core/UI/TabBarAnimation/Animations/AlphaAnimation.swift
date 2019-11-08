import UIKit

open class AlphaAnimation: ItemAnimation {

    open override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playAlphaAnimation(icon)
        playAlphaAnimation(textLabel)
    }
    open override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {

    }
}
