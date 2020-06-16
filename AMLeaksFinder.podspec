Pod::Spec.new do |s|
s.name         = 'AMLeaksFinder'
s.version      = '1.2.5'
s.summary      = 'A small tool for automatically detecting the [controller memory leak] in the project'
s.homepage     = 'https://github.com/liangdahong/AMLeaksFinder'
s.license      = 'MIT'
s.authors      = {'梁大红' => 'ios@liangdahong.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/liangdahong/AMLeaksFinder.git', :tag => s.version}
s.source_files = 'AMLeaksFinder/**/*.{h,m}'
s.resource     = 'AMLeaksFinder/**/*.{bundle,xib}'
s.requires_arc = true
end
