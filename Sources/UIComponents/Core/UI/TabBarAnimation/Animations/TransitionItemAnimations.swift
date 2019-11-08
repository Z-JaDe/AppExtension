import UIKit
open class TransitionItemAnimations: ItemAnimation {

    open var transitionOptions: UIView.AnimationOptions

    public override init() {
        transitionOptions = UIView.AnimationOptions()
        super.init()
    }

    open override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {

        playAlphaAnimation(textLabel)

        UIView.transition(with: icon, duration: TimeInterval(duration), options: transitionOptions, animations: {
        }, completion: { _ in
        })
    }

    open override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
    }
}

public class FlipLeftTransitionItemAnimations: TransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromLeft
    }
}

public class FlipRightTransitionItemAnimations: TransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromRight
    }
}

public class FlipTopTransitionItemAnimations: TransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromTop
    }
}

public class FlipBottomTransitionItemAnimations: TransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromBottom
    }
}
