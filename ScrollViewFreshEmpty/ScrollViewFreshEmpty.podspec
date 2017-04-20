Pod::Spec.new do |s|
  s.name             = 'ScrollViewFreshEmpty'
  s.version          = '0.0.7'
  s.summary          = '整合UIScrollView的下拉刷新、空页面显示，简化MJRefresh和DZNEmptyDataSet的使用。'
  s.homepage         = 'https://github.com/wochen85/ScrollViewFreshEmpty'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CHAT' => '312163862@qq.com' }
  s.source           = { :git => 'https://github.com/wochen85/ScrollViewFreshEmpty.git', :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.dependency 'MJRefresh'
  s.dependency 'DZNEmptyDataSet'

  s.source_files = 'ScrollViewFreshEmpty/ScrollViewFreshEmpty/*.{h,m}'

end
