
Pod::Spec.new do |s|
  s.name         = 'SJSlider'
  s.version      = '1.2.3'
  s.summary      = 'Slide view with buffer / slide / progress.'
  s.description  = 'https://github.com/changsanjiang/SJSlider/blob/master/README.md'
  s.homepage     = 'https://github.com/changsanjiang/SJSlider'
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { 'SanJiang' => 'changsanjiang@gmail.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/changsanjiang/SJSlider.git', :tag => "v#{s.version}" }
  s.source_files  = 'SJSlider/*.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
  s.dependency 'Masonry'
end
