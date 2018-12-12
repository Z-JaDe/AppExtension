source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
use_frameworks!
#Framework

install! 'cocoapods', :deterministic_uuids => false

abstract_target 'BaseCore' do
    pod 'Validation', :path => '~/Desktop/wallet-ios/BaseSupport/Validation'
    pod 'Encryption', :path => '~/Desktop/wallet-ios/BaseSupport/Encryption'
    pod 'FunctionalSwift', :path => '~/Desktop/wallet-ios/BaseSupport/FunctionalSwift'
    pod 'CocoaExtension', :path => '~/Desktop/wallet-ios/BaseSupport/CocoaExtension'
    pod 'ModalManager', :path => '~/Desktop/wallet-ios/BaseSupport/ModalManager'
    
    target:'Core' do
    end
    target:'AnimatedTransition' do
    end
    target:'UserNotificationManager' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
    end
    target:'RouterManager' do
    end
    target:'UIComponents' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
    end
    target:'EmptyDataSet' do
        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
    end

    abstract_target 'CommonPods' do
        pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
        pod 'RxGesture'
        pod 'RxSwiftExt'
        pod 'RxAnimated'
        pod 'RxOptional'
        pod 'RxKeyboard'

        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'

        pod 'SwiftLint'


        target:'RxExtensions' do
        end
        target:'ProjectBasic' do
            pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
            pod 'MBProgressHUD'
            pod 'SwiftyUserDefaults'
        end
        target:'List' do
            pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
            pod 'DifferenceKit'
            pod 'MJRefresh', :git => 'https://github.com/CoderMJLee/MJRefresh'
        end

        target:'AppExtension' do
            target 'AppExtensionUITests' do
                inherit! :search_paths
            end
            target 'AppExtensionTests' do
                inherit! :search_paths
            end
        end
    end
end





post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
