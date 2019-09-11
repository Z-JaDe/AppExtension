Pod::Spec.new do |s|
    s.name             = "AppExtension"
    s.version          = "1.0.0"
    s.summary          = "App框架"
    s.description      = <<-DESC
    App框架
    如有针对性设计，把podspec copy一份，podfile中指定下path就行了
    DESC
    s.homepage         = "https://github.com/Z-JaDe"
    s.license          = 'MIT'
    s.author           = { "ZJaDe" => "zjade@outlook.com" }
    s.source           = { :git => "https://github.com/Z-JaDe/AppExtension.git" }
    
    s.requires_arc          = true
    
    s.ios.deployment_target = '10.0'
    s.swift_version = '5.0'
    
    s.default_subspec = "Default"

    s.xcconfig = { 'OTHER_SWIFT_FLAGS' => '"-D" "AppExtensionPods"' }

    #基础模块
    s.subspec "Async" do |ss|
        ss.source_files  = "Sources/Async/**/*.{swift}"
    end
    s.subspec "Codable" do |ss|
        ss.source_files  = "Sources/Codable/**/*.{swift}"
    end
    s.subspec "Animater" do |ss|
        ss.source_files  = "Sources/Animater/**/*.{swift}"
    end
    s.subspec "AnimatedTransition" do |ss|
        ss.source_files  = "Sources/AnimatedTransition/**/*.{swift}"
        ss.dependency "AppExtension/Animater"
    end
    s.subspec "Core" do |ss|
        ss.source_files  = "Sources/Core/**/*.{swift}"

        ss.dependency "AppExtension/Async"
        ss.dependency "CocoaExtension"
        ss.dependency "Encryption"
        ss.dependency "FunctionalSwift"
        ss.dependency "Validation"
        ss.dependency "ModalManager"
    end
    #子模块
    s.subspec "UserNotificationManager" do |ss|
        ss.source_files  = "Sources/UserNotificationManager/**/*.{swift}"
        ss.dependency "AppExtension/Core"

        ss.dependency "RxSwift"
    end
    s.subspec "List" do |ss|
        ss.source_files  = "Sources/List/**/*.{swift}"
        ss.dependency "AppExtension/Core"
        ss.dependency "DifferenceKit"
    end
    s.subspec "Network" do |ss|
        ss.source_files  = "Sources/Network/**/*.{swift}"
        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "RxSwift"
        ss.dependency "Alamofire"
    end
    s.subspec "RxExtensions" do |ss|
        ss.source_files  = "Sources/RxExtensions/**/*.{swift}"
        ss.dependency "AppExtension/Core"

        ss.dependency "RxSwift"
        ss.dependency "RxCocoa"
        ss.dependency "RxGesture"
        ss.dependency "RxSwiftExt"
        ss.dependency "RxOptional"
    end
    #架构相关
    s.subspec "NavigationFlow" do |ss|
        ss.source_files  = "Sources/NavigationFlow/**/*.{swift}"

        ss.dependency "AppExtension/RxExtensions"
    end
    s.subspec "Coordinator" do |ss|
        ss.source_files  = "Sources/Coordinator/**/*.{swift}"

        ss.dependency "AppExtension/Core"
    end

    #组件
    s.subspec "UIComponents" do |ss|
        ss.source_files  = "Sources/UIComponents/Core/**/*.{swift}"
        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "AppExtension/Animater"
    end
    s.subspec "EmptyDataSet" do |ss|
        ss.source_files  = "Sources/UIComponents/EmptyDataSet/**/*.{swift}"
        ss.dependency "AppExtension/UIComponents"
    end
    s.subspec "ScrollExtensions" do |ss|
        ss.source_files  = "Sources/UIComponents/ScrollExtensions/**/*.{swift}"
        ss.dependency "AppExtension/UIComponents"
    end
    s.subspec "CollectionKitExtensions" do |ss|
        ss.source_files  = "Sources/UIComponents/CollectionKitExtensions/**/*.{swift}"
        ss.dependency "AppExtension/UIComponents"
        ss.dependency "CollectionKit"
    end

    #项目基础
    s.subspec "ProjectBasic" do |ss|
        ss.source_files  = "Sources/ProjectBasic/**/*.{swift}"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "AppExtension/UIComponents"
        ss.dependency "AppExtension/RxExtensions"
        ss.dependency "AppExtension/Network"
        #List
        ss.dependency "AppExtension/List"
        ss.dependency "AppExtension/EmptyDataSet"

        ss.dependency "SnapKit"
    end
    #项目集成
    s.subspec "MVCProject" do |ss|
        ss.dependency "AppExtension/ProjectBasic"

        ss.dependency "AppExtension/AnimatedTransition"
        ss.dependency "AppExtension/UserNotificationManager"

        #可选扩展
        ss.dependency "SwiftyUserDefaults"
        ss.dependency "MBProgressHUD"
        ss.dependency "Kingfisher"
        ss.dependency "MJRefresh"
        ss.dependency "RxSwift"
        ss.dependency "RxCocoa"
    end
    s.subspec "Default" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/ScrollExtensions"
    end
    s.subspec "MVVMC" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/ScrollExtensions"
        ss.dependency "AppExtension/Coordinator"
        ss.dependency "ReSwift"
    end
    s.subspec "MVCFlow" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/NavigationFlow"
        #ss.dependency "AppExtension/CollectionKitExtensions"
    end

end
