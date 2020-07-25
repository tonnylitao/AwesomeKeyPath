#
# Be sure to run `pod lib lint AwesomeKeyPath.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AwesomeKeyPath'
  s.version          = '0.4.5'
  s.summary          = 'Use Swift Keypath in DataBinding, Predication, Testing etc.'
  s.swift_versions   = '5'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Swift KeyPath is awesome, this library is a collection of how to apply KeyPath in development
                       DESC

  s.homepage         = 'https://github.com/tonnylitao/AwesomeKeyPath'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tonnylitao' => 'tonny.litao@gmail.com' }
  s.source           = { :git => 'https://github.com/tonnylitao/AwesomeKeyPath.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AwesomeKeyPath/Classes/KPDataBinding/**/*'
  
  s.subspec 'Validation' do |validation|
    validation.source_files = 'AwesomeKeyPath/Classes/KPValidation/*'
  end
  
  s.subspec 'Kit' do |kit|
    kit.source_files = 'AwesomeKeyPath/Classes/KPKit/*'
  end
  
  # s.resource_bundles = {
  #   'AwesomeKeyPath' => ['AwesomeKeyPath/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
