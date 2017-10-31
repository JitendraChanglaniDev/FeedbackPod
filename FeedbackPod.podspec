#
# Be sure to run `pod lib lint feedbackLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'FeedbackPod'
s.version          = '1.1.12'
s.summary          = 'This is pod that can be used for integrating feedback screen to your project.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
This is pod that can be used for integrating feedback screen to your project. It will keep track of feedback for your project.
DESC

s.homepage         = 'https://github.com/JitendraChanglaniDev/FeedbackPod'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'JitendraChanglaniDev' => 'jitendrachanglani@yahoo.co.in' }
s.source           = { :git => 'https://github.com/JitendraChanglaniDev/FeedbackPod.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'
s.source_files  = "FeedbackPod", "FeedbackPod/**/*.{swift,c,h,xib,png}"

# s.resource_bundles = {
# 'feedbackLib' => ['feedbackLib/Assets/**/*.{png,xib}']
#}

s.libraries = 'z'
s.public_header_files = 'FeedbackPod/Zip/*.h'

s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(SRCROOT)/FeedbackPod/FeedbackPod/Zip/minizip/**','LIBRARY_SEARCH_PATHS' => '$(SRCROOT)/FeedbackPod/FeedbackPod/'}


s.preserve_paths  = 'FeedbackPod/Zip/minizip/module.modulemap'
#s.preserve_paths  = 'FeedbackPod/Zip/minizip/*'


s.frameworks = 'UIKit'
s.dependency 'MBProgressHUD', '~> 0.9.2'
s.dependency 'ReachabilitySwift', '~> 3'
s.dependency 'SDWebImage', '~>3.7'

end
