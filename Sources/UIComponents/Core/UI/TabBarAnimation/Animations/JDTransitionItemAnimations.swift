import UIKit
open class JDTransitionItemAnimations: JDItemAnimation {

    open var transitionOptions: UIView.AnimationOptions

    public override init() {
        transitionOptions = UIView.AnimationOptions()
        super.init()
    }

    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {

        playAlphaAnimation(textLabel)

        UIView.transition(with: icon, duration: TimeInterval(duration), options: transitionOptions, animations: {
        }, completion: { _ in
        })
    }

    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
    }
}

public class JDFlipLeftTransitionItemAnimations: JDTransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromLeft
    }
}

public class JDFlipRightTransitionItemAnimations: JDTransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromRight
    }
}

public class JDFlipTopTransitionItemAnimations: JDTransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromTop
    }
}

public class JDFlipBottomTransitionItemAnimations: JDTransitionItemAnimations {
    public override init() {
        super.init()
        transitionOptions = UIView.AnimationOptions.transitionFlipFromBottom
    }
}
