
Pod::Spec.new do |s|
  s.name             = 'PayMayaSDK'
  s.version          = '0.1.0'
  s.summary          = 'Easily enable your iOS app to accept credit and debit card payments'
  s.description      = <<-DESC
The PayMaya iOS SDK is a library that allows you to easily add credit and debit card as payment options to your mobile application.
                       DESC

  s.homepage         = 'https://github.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PayMaya Philippines, Inc.' => '' }
  s.source           = { :git => 'https://github.com/PayMaya/PayMaya-iOS-SDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.0', '5.1']
  s.source_files = 'PayMayaSDK/PayMayaSDK/**/*.swift'

  s.frameworks = 'UIKit', 'XCTest', 'Foundation'
end
