source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
#Framework

install! 'cocoapods', :deterministic_uuids => false

def baseCore
    pod 'Validation', :path => '~/Desktop/wallet-ios/BaseSupport/Validation'
    pod 'Encryption', :path => '~/Desktop/wallet-ios/BaseSupport/Encryption'
    pod 'FunctionalSwift', :path => '~/Desktop/wallet-ios/BaseSupport/FunctionalSwift'
    pod 'CocoaExtension', :path => '~/Desktop/wallet-ios/BaseSupport/CocoaExtension'
    pod 'ModalManager', :path => '~/Desktop/wallet-ios/BaseSupport/ModalManager'
end
def rx
    pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
end
def rxExtension
    rx
    pod 'RxGesture'
    pod 'RxSwiftExt'
    pod 'RxAnimated'
    pod 'RxOptional'
    pod 'RxKeyboard'
end
def snapKit
    pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
end

target:'Core' do
    baseCore
end
target:'Coordinator' do
    baseCore
end
target:'AnimatedTransition' do
    baseCore
end
target:'UserNotificationManager' do
    baseCore
    pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
end
target:'List' do
    baseCore
    rx
    pod 'DifferenceKit'
end
target:'UIComponents' do
    baseCore
    rx
    snapKit
    target:'ScrollExtensions' do
    end
    target:'CollectionKitExtensions' do
        pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit'
    end
end
target:'EmptyDataSet' do
    baseCore
    rx
    snapKit
end
target:'RxExtensions' do
    baseCore
    rxExtension
end
target:'NavigationFlow' do
    baseCore
    rxExtension
end

def commonPods
    baseCore
    rxExtension
    snapKit

    pod 'SwiftLint'

    pod 'Alamofire'

    pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
    pod 'Kingfisher'
    pod 'MBProgressHUD'
    pod 'SwiftyUserDefaults'

    pod 'MJRefresh', :git => 'https://github.com/CoderMJLee/MJRefresh'
    pod 'DifferenceKit'
end

target:'ProjectBasic' do
    commonPods
    pod 'Alamofire'

    pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
    pod 'Kingfisher'
    pod 'MBProgressHUD'
    pod 'SwiftyUserDefaults'
    pod 'ReSwift'
end

target:'AppExtension' do
    commonPods
    target 'AppExtensionUITests' do
        inherit! :search_paths
    end
    target 'AppExtensionTests' do
        inherit! :search_paths
    end
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
