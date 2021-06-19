source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks! :linkage => :static
#Framework

install! 'cocoapods', deterministic_uuids: false, generate_multiple_pod_projects: true

def userPod (name)
  pod name, :path => "LocalPods/#{name}"
end
#def userForkPod (name)
#  pod name, :path => "LocalPods/Fork/#{name}"
#end
######################################################################################
def baseCorePod
  userPod 'FunctionalSwift'
  userPod 'CocoaExtension'
end

def collectionKitPod
  pod 'CollectionKit'
end

def networkPod
  pod 'Alamofire'
  userPod 'RxNetwork'
  pod 'Kingfisher'
end

def rxPod (hasCocoa = true)
  pod 'RxSwift'
  if hasCocoa
    pod 'RxCocoa'
  end
end

def rxExtensionPod
  rxPod
  pod 'RxGesture'
  pod 'RxSwiftExt'
  pod 'RxOptional'
  #    pod 'RxAnimated'
  #    pod 'RxKeyboard'
end

def snapKitPod
  pod 'SnapKit'
end

target:'Core' do
  baseCorePod
end
target:'Codable' do
  pod "AnyCodable"
  pod "BetterCodable"
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

  networkPod
  userPod 'ModalManager'
  userPod 'Validation' #校验库 正则 身份证 银行卡
  userPod 'Encryption' #加密库 RSA MD5
  userPod 'iCarouselSwift'

  pod 'MBProgressHUD'
  pod 'SwiftyUserDefaults'
  
  pod 'Motion'
  collectionKitPod #仅测试
  
  pod 'MJRefresh'
end

def projectBasicPod
  commonPods

  pod 'MBProgressHUD'
  pod 'ReSwift'
end
target:'ProjectBasic' do
  projectBasicPod
end

target:'AppExtension' do
  pod 'SwiftLint'

  projectBasicPod
  target 'AppExtensionUITests'
  target 'AppExtensionTests'
end


