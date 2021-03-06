#
# Be sure to run `pod lib lint TableViewLiaison.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TableViewLiaison'
  s.version          = '2.0.1'
  s.summary          = 'Framework to help you better manage UITableViews.'
  s.description      = 'TableViewLiaison abstracts and simplifies UITableView construction and management.'
  s.homepage         = 'https://github.com/dylanshine/TableViewLiaison'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dylan Shine' => 'dylan@shinelabs.dev' }
  s.source           = { :git => 'https://github.com/dylanshine/TableViewLiaison.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'TableViewLiaison/Classes/**/*'
  s.swift_version = '5.0'
end
