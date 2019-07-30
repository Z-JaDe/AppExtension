source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
#Framework

install! 'cocoapods', deterministic_uuids: false, generate_multiple_pod_projects: true

def userPod (name)
  pod name, :path => "BaseSupport/#{name}"
end

def baseCorePod
  userPod 'Validation'
  userPod 'Encryption'
  userPod 'FunctionalSwift'
  userPod 'CocoaExtension'
  userPod 'ModalManager'
end

def collectionKitPod
  pod 'CollectionKit', :git => 'https://github.com/SoySauceLab/CollectionKit.git'
end

def rxPod (hasCocoa = true)
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  if hasCocoa
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
  end
end

def rxExtensionPod
  rxPod
  userPod 'RxGesture'
  userPod 'RxSwiftExt'
  userPod 'RxOptional'
  #    pod 'RxAnimated'
  #    pod 'RxKeyboard'
end

def snapKitPod
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit'
end

target:'Core' do
  baseCorePod
end
target:'Coordinator' do
  baseCorePod
end
target:'AnimatedTransition' do
  baseCorePod
end
target:'UserNotificationManager' do
  baseCorePod
  rxPod hasCocoa = false
end
target:'List' do
  baseCorePod
  rxPod
  pod 'DifferenceKit'
end
target:'UIComponents' do
  baseCorePod
  rxPod
  snapKitPod
  target:'ScrollExtensions' do
  end
  target:'CollectionKitExtensions' do
    collectionKitPod
  end
end
target:'EmptyDataSet' do
  baseCorePod
  rxPod
  snapKitPod
end
target:'RxExtensions' do
  baseCorePod
  rxExtensionPod
end
target:'NavigationFlow' do
  baseCorePod
  rxExtensionPod
end

def commonPods
  baseCorePod
  rxExtensionPod
  snapKitPod
  
  pod 'SwiftLint'
  
  pod 'Alamofire'
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  userPod 'SwiftyUserDefaults'
  
  pod 'Motion'
  collectionKitPod #仅测试
  
  pod 'MJRefresh'
  pod 'DifferenceKit'
end

def projectBasicPod
  commonPods
  pod 'Alamofire'
  
  pod 'Kingfisher'
  pod 'MBProgressHUD'
  pod 'ReSwift', :git => 'https://github.com/ReSwift/ReSwift.git'
end
target:'ProjectBasic' do
  projectBasicPod
end

target:'AppExtension' do
  projectBasicPod
  target 'AppExtensionUITests' do
    inherit! :search_paths
  end
  target 'AppExtensionTests' do
    inherit! :search_paths
  end
end


