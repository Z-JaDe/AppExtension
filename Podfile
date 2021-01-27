source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks! :linkage => :static
#Framework

install! 'cocoapods', deterministic_uuids: false, generate_multiple_pod_projects: true

def userPod (name)
  pod name, :path => "LocalPods/#{name}"
end
def userForkPod (name)
  pod name, :path => "LocalPods/Fork/#{name}"
end
######################################################################################
def baseCorePod
  userPod 'FunctionalSwift'
  userPod 'CocoaExtension'
end

def collectionKitPod
  userForkPod 'CollectionKit'
end

def networkPod
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire'
  userPod 'RxNetwork'
  pod 'Kingfisher'
end

def rxPod (hasCocoa = true)
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift'
  if hasCocoa
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift'
  end
end

def rxExtensionPod
  rxPod
  userForkPod 'RxGesture'
  userForkPod 'RxSwiftExt'
  userForkPod 'RxOptional'
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
######################################################################################
def commonPods
  baseCorePod
  rxExtensionPod
  snapKitPod
  
  pod 'SwiftLint'

  networkPod
  userPod 'ModalManager'
  userPod 'Validation' #校验库 正则 身份证 银行卡
  userPod 'Encryption' #加密库 RSA MD5
  userPod 'iCarouselSwift'

  pod 'MBProgressHUD'
  userForkPod 'SwiftyUserDefaults'
  
  pod 'Motion'
  collectionKitPod #仅测试
  
  pod 'MJRefresh'
  pod 'DifferenceKit'
end

def projectBasicPod
  commonPods

  pod 'MBProgressHUD'
  pod 'ReSwift', :git => 'https://github.com/ReSwift/ReSwift.git'
end
target:'ProjectBasic' do
  projectBasicPod
end

target:'AppExtension' do
  projectBasicPod
  target 'AppExtensionUITests'
  target 'AppExtensionTests'
end


