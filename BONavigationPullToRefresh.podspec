Pod::Spec.new do |s|
s.name             = 'BONavigationPullToRefresh'
s.version          = '0.3.0'
s.summary       = 'Add PullToRefresh to a ScrollView with a custom view in UINavigationBar'
s.description     = 'Add PullToRefresh to a ScrollView with a custom view in UINavigationBar.'
s.homepage         = 'https://github.com/bmoliveira/BONavigationPullToRefresh'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Bruno Oliveira' => 'bm.oliveira.dev@gmail.com' }
s.source           = { :git => 'https://github.com/bmoliveira/BONavigationPullToRefresh.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/_bmoliveira'
s.ios.deployment_target = '8.0'
s.source_files = 'BONavigationPullToRefresh/Classes/**/*'
end
