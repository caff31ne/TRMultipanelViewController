Pod::Spec.new do |s|
  s.name     = 'TRMultipanelViewController'
  s.version  = '0.1'
  s.platform = :ios, '6.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'iOS view controller with center content and panels on both sides'
  s.homepage = 'https://github.com/incaffeine/TRMultipanelViewController'
  s.author   = { 'Vitali Bondur' => 'bondur@gmail.com' }
  s.requires_arc = true
  s.source   = { :git => 'https://github.com/incaffeine/TRMultipanelViewController.git', :branch => 'master', :tag => s.version.to_s }
  s.source_files = 'multipanel/*.{h,m}'
  s.public_header_files = 'multipanel/TRMultipanelViewController.h'
end