#
# Be sure to run `pod lib lint XHBrowseView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHBrowseView'
  s.version          = '0.1.0'
  s.summary          = '仿今日头条大图浏览控件.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 今日头条大图浏览的效果
                       DESC

  s.homepage         = 'https://github.com/zxhiOS/XHBrowseView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zxhiOS' => '997600269@qq.com' }
  s.source           = { :git => 'https://github.com/zxhiOS/XHBrowseView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XHBrowseView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XHBrowseView' => ['XHBrowseView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
   s.dependency 'SDWebImage'
   
end
