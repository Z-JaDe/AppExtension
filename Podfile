source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
#Framework

install! 'cocoapods', deterministic_uuids: false, generate_multiple_pod_projects: true

def baseCore
  pod 'Validation', :path => 'BaseSupport/Validation'
  pod 'Encryption', :path => 'BaseSupport/Encryption'
  pod 'FunctionalSwift', :path => 'BaseSupport/FunctionalSwift'
  pod 'CocoaExtension', :path => 'BaseSupport/CocoaExtension'
  pod 'ModalManager', :path => 'BaseSupport/ModalManager'
end
def rx
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
end
def rxExtension
  rx
  pod 'RxGesture', :path => 'BaseSupport/RxGesture'
  pod 'RxSwiftExt', :path => 'BaseSupport/RxSwiftExt'
  pod 'RxOptional', :path => 'BaseSupport/RxOptional'
  #    pod 'RxAnimated'
  #    pod 'RxKeyboard'
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
    pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit.git'
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
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'SwiftyUserDefaults', :path => 'BaseSupport/SwiftyUserDefaults'
  
  pod 'Motion'
  pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit.git'  #仅测试
  
  pod 'MJRefresh'
  pod 'DifferenceKit'
end

def projectBasic
  commonPods
  pod 'Alamofire'
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'ReSwift', :git => 'https://github.com/ReSwift/ReSwift.git'
end
target:'ProjectBasic' do
  projectBasic
end

target:'AppExtension' do
  projectBasic
  target 'AppExtensionUITests' do
    inherit! :search_paths
  end
  target 'AppExtensionTests' do
    inherit! :search_paths
  end
end


