
Pod::Spec.new do |s|
  s.name         = "SDK"
  s.version      = "1.0.0"
  s.summary      = "sdk"

  s.homepage     = "sdk"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "zjade" => "zjade@outlook.com" }
  s.social_media_url   = "https://github.com/Z-JaDe"

  s.requires_arc = true
  s.ios.deployment_target = "10.0"
  s.swift_version = '5.0'
  s.source       = { :git => "https://github.com/Z-JaDe/AppExtension.git" }

  s.default_subspecs = "Core"
#  s.static_framework  =  true
  s.xcconfig = {
#    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'OTHER_LDFLAGS' => '"-all_load"'
  }
  
  s.subspec "Core" do |ss|
    ss.dependency "AppExtension"
    ss.source_files = "Core/**/*.{swift,h}"

    ss.dependency "SDK/Alipay"
    ss.dependency "SDK/Wechat"
    ss.dependency "SDK/Tencent"
  end

  s.subspec "Alipay" do |ss|
    ss.source_files = "Alipay/**/*.{swift,h}"
#    ss.public_header_files = "Alipay/Alipay-Header.h"
    #
     ss.resource  = "Alipay/**/*.bundle"
     ss.vendored_frameworks = "Alipay/**/*.framework"
     ss.frameworks = "SystemConfiguration", "CoreTelephony", "QuartzCore", "CoreText", "CoreGraphics", "UIKit", "Foundation", "CFNetwork", "CoreMotion"
     ss.libraries = "z", "c++"
     # ss.dependency "UTDID"

    #
#    ss.dependency "AlipaySDK-iOS"
  end
  s.subspec "Wechat" do |ss|
    ss.source_files = "Wechat/**/*.{swift,h}"
#    ss.public_header_files = "Wechat/WeChat-Header.h"

    #
    ss.resource  = "Wechat/**/*.bundle"
    ss.vendored_libraries = "Wechat/**/*.a"
    ss.frameworks = "SystemConfiguration", "Security", "CoreTelephony", "CFNetwork", "UIKit", "CoreGraphics"
    ss.libraries = "z", "c++", "sqlite3.0"

    #ss.dependency "WechatOpenSDK"
    ss.dependency "Alamofire"
  end
  s.subspec "Tencent" do |ss|
    ss.source_files = "Tencent/**/*.{swift,h}"
#    ss.public_header_files   = "Tencent/Tencent-Header.h"

    ss.vendored_frameworks = "Tencent/**/*.framework"
  end

end
