#
#  Be sure to run `pod spec lint LMChatCore_iOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = 'LMChatCore_iOS'
  spec.summary      = 'A short description of LMChatCore_iOS.'
  spec.homepage     = 'https://likeminds.community/'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'MIT', :file => '../LICENSE' }
  spec.authors      = { "pushpendrasingh" => "pushpendra.singh@likeminds.community" }
  spec.source       = { :git => "https://github.com/LikeMindsCommunity/LikeMinds-iOS-Chat-Sample-App", :tag => "#{spec.version}" }
  spec.source_files = 'LMChatCore_iOS/LMChatCore_iOS/Source/**/*.swift'
  spec.resource_bundles = {
     'LMChatCore_iOS' => ['LMChatCore_iOS/LMChatCore_iOS/Source/Assets/*.{xcassets}']
  }
  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.0'
  spec.requires_arc = true
  spec.dependency 'Giphy'
  spec.dependency "AWSCore"
  spec.dependency "AWSCognito"
  spec.dependency "AWSS3"
  #spec.dependency 'BSImagePicker'
  spec.dependency "FirebaseCore"
  spec.dependency "FirebaseMessaging"
  spec.dependency "FirebaseDatabase"
  spec.dependency 'LMChatUI_iOS'
  spec.dependency 'LikeMindsChat'
end
