#
# Be sure to run `pod lib lint feedbackLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'FeedbackPod'
s.version          = '1.0.4'
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
s.author           = { 'jitendrachanglani@yahoo.co.in' => 'jitendra.changlani@kahunasystems.com' }
s.source           = { :git => 'https://github.com/JitendraChanglaniDev/FeedbackPod.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.0'
s.source_files  = "FeedbackPod", "FeedbackPod/**/*.{swift,xib,png}"

# s.resource_bundles = {
# 'feedbackLib' => ['feedbackLib/Assets/**/*.{png,xib}']
#}

#s.public_header_files = 'Pod/Classes/**/*.{h,m,swift,c,png,}'
s.frameworks = 'UIKit'
s.dependency 'MBProgressHUD', '~> 0.9.2'
s.dependency 'ReachabilitySwift', '~> 3'
s.dependency 'SDWebImage', '~>3.7'
s.dependency 'Zip', '~> 1.0'

s.pod_target_xcconfig = {
'OTHER_LDFLAGS' => '$(inherited) -undefined dynamic_lookup -ObjC'
}
end
