Pod::Spec.new do |s|
    s.name             = "AppExtension"
    s.version          = "0.0.1"
    s.summary          = "App框架"
    s.description      = <<-DESC
    App框架
    DESC
    s.homepage         = "https://github.com/Z-JaDe"
    s.license          = 'MIT'
    s.author           = { "ZJaDe" => "zjade@outlook.com" }
    s.source           = { :git => "https://github.com/Z-JaDe/AppExtension.git"}
    
    s.requires_arc          = true
    
    s.ios.deployment_target = '9.0'
    
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
    s.subspec "RxExtensions" do |ss|
        ss.source_files  = "Sources/RxExtensions/**/*.{swift}"
        ss.dependency "AppExtension/Core"

        ss.dependency "RxSwift"
        ss.dependency "RxCocoa"
        ss.dependency "RxGesture"
        ss.dependency "RxSwiftExt"
        ss.dependency "RxOptional"
    end
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
        ss.source_files  = "Sources/UIComponents/**/*.{swift}"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "AppExtension/Animater"
        ss.dependency "SnapKit"

        ss.subspec "EmptyDataSet" do |sss|
            sss.source_files  = "Sources/UIComponents/EmptyDataSet/**/*.{swift}"
        end
        ss.subspec "ScrollExtensions" do |sss|
            sss.source_files  = "Sources/UIComponents/ScrollExtensions/**/*.{swift}"
        end
        ss.subspec "CollectionKitExtensions" do |sss|
            sss.source_files  = "Sources/UIComponents/CollectionKitExtensions/**/*.{swift}"
            sss.dependency "CollectionKit"
        end
    end

    #项目基础
    s.subspec "ProjectBasic" do |ss|
        ss.source_files  = "Sources/ProjectBasic/**/*.{swift}"

        ss.dependency "AppExtension/Core"
        ss.dependency "AppExtension/Codable"
        ss.dependency "AppExtension/UIComponents"
        ss.dependency "AppExtension/RxExtensions"
        ss.dependency "Alamofire"
        #List
        ss.dependency "AppExtension/List"

    end
    #项目集成
    s.subspec "MVCProject" do |ss|
        ss.dependency "AppExtension/ProjectBasic"

        ss.dependency "AppExtension/AnimatedTransition"
        ss.dependency "AppExtension/UserNotificationManager"

        #可选扩展
        ss.dependency "SwiftyUserDefaults"
        ss.dependency "Rx+Kingfisher"
        ss.dependency "MBProgressHUD"
        ss.dependency "MJRefresh"
        ss.dependency "RxSwift"
        ss.dependency "RxCocoa"
    end
    s.subspec "Default" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/UIComponents/ScrollExtensions"
    end
    s.subspec "MVVMC" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/UIComponents/ScrollExtensions"
        ss.dependency "AppExtension/Coordinator"
        ss.dependency "ReSwift"
    end
    s.subspec "MVCFlow" do |ss|
        ss.dependency "AppExtension/MVCProject"
        ss.dependency "AppExtension/NavigationFlow"
        #ss.dependency "AppExtension/UIComponents/CollectionKitExtensions"
    end

end
