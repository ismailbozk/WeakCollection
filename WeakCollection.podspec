#
# Be sure to run `pod lib lint WeakCollection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WeakCollection'
  s.version          = '1.0.0'
  s.summary          = 'A weak reference retaining collection for Swift.'
  s.swift_versions   = ['5.0', '5.1']

  s.description      = <<-DESC
A weak refence retaining collection, which enables the Multicast delegation pattern on Swift.
                       DESC

  s.homepage         = 'https://github.com/ismailbozk/WeakCollection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ismailbozk' => 'ismail.bozkurt@hbc.com' }
  s.source           = { :git => 'https://github.com/ismailbozk/WeakCollection.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WeakCollection/Classes/**/*'
  
end
