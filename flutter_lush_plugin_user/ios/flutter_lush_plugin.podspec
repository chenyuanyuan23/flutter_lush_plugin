#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_yun_ceng.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_lush_plugin'
  s.version          = '0.0.1'
  s.summary          = '三方震动工具'
  s.description      = <<-DESC
三方震动工具
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '' => '' }
  s.source           = { :path => '.' }
  # s.ios.vendored_frameworks = 'Frameworks/Lovense.xcframework'
  # s.vendored_frameworks = 'Lovense.xcframework'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.static_framework = true

  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
