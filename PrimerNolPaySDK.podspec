#
# Be sure to run `pod lib lint PrimerNolPaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PrimerNolPaySDK'
  s.version          = '1.0.0'
  s.summary          = 'A wrapper for the Nol SDK'
  s.description      = <<-DESC
A wrapper around the Nol payment SDK.
                       DESC

  s.homepage         = 'https://primer.io/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Primer' => 'dx@primer.io' }
  s.source           = { :git => 'https://github.com/primer-io/primer-nol-pay-sdk-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.ios.source_files = 'Sources/PrimerNolPaySDK/Classes/*.{swift}'
  s.ios.frameworks  = 'Foundation', 'UIKit'
  s.ios.vendored_frameworks = 'Sources/Frameworks/TransitSDK.framework'

end
