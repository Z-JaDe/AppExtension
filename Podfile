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
    target:'Custom' do
    end
    target:'UIComponents' do
        pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
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
        pod 'Rx+Kingfisher', :path => '~/Desktop/wallet-ios/BaseSupport/RxKingfisher'
        pod 'Kingfisher', :git => 'https://github.com/onevcat/Kingfisher'
        pod 'Result'

        pod 'SwiftLint'

        target:'Third' do
        end
        target:'AnimatedTransition' do
        end
        target:'UserNotificationManager' do
        end
        target:'RouterManager' do
        end
        target:'List' do
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
