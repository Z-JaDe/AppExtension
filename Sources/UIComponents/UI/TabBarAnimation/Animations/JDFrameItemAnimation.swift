import UIKit
import QuartzCore

/// The JDFrameItemAnimation class provides keyframe animation.
public class JDFrameItemAnimation: JDItemAnimation {

    @nonobjc fileprivate var animationImages: [CGImage] = []

    @IBInspectable open var isDeselectAnimation: Bool = true

    @IBInspectable open var imagesPath: String!

    override open func awakeFromNib() {
        guard let path = Bundle.main.path(forResource: imagesPath, ofType: "plist") else {
            fatalError("don't found plist")
        }
        guard case let animationImagesName as [String] = NSArray(contentsOfFile: path) else {
            fatalError()
        }
        createImagesArray(animationImagesName)

        let selectedImageName = animationImagesName[animationImagesName.endIndex - 1]
        selectedImage = UIImage(named: selectedImageName)
    }

    func createImagesArray(_ imageNames: [String]) {
        for name in imageNames {
            if let image = UIImage(named: name)?.cgImage {
                animationImages.append(image)
            }
        }
    }
    open func setAnimationImages(_ images: [UIImage]) {
        var animationImages = [CGImage]()
        for image in images {
            if let cgImage = image.cgImage {
                animationImages.append(cgImage)
            }
        }
        self.animationImages = animationImages
    }
    // MARK: -
    override open func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playFrameAnimation(icon, images: animationImages)
        playAlphaAnimation(textLabel)
    }

    override open func deselectAnimation(_ icon: UIImageView, textLabel: UILabel) {
        if isDeselectAnimation {
            playFrameAnimation(icon, images: animationImages.reversed())
        }
    }

    @nonobjc func playFrameAnimation(_ icon: UIImageView, images: [CGImage]) {
        let frameAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.KeyFrame)
        frameAnimation.calculationMode = CAAnimationCalculationMode.discrete
        frameAnimation.duration = TimeInterval(duration)
        frameAnimation.values = images
        frameAnimation.repeatCount = 1
        frameAnimation.isRemovedOnCompletion = false
        frameAnimation.fillMode = CAMediaTimingFillMode.forwards
        icon.layer.add(frameAnimation, forKey: nil)
    }
}
