#
# Be sure to run `pod lib lint Downloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Downloader'
  s.version          = '0.1.0'
  s.summary          = 'Downloader is a small utility library for downloading and caching files'
  s.description      = 'Downloader use OperationQueue and LRUCache for downloading and caching files'
  s.homepage         = 'https://github.com/Majid Jabrayilov/Downloader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Majid Jabrayilov' => 'cmecid@gmail.com' }
  s.source           = { :git => 'https://github.com/Majid Jabrayilov/Downloader.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mecid'
  s.ios.deployment_target = '10.0'
  s.source_files = 'Downloader/Classes/**/*'
  s.frameworks = 'UIKit'
end
