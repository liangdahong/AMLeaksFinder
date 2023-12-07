Pod::Spec.new do |s|
s.name         = 'AMLeaksFinder'
s.version      = '2.2.7'
s.summary      = 'A small tool for automatically detecting the [controller view memory leak] in the project'
s.homepage     = 'https://github.com/liangdahong/AMLeaksFinder'
s.license      = 'MIT'
s.authors      = {'liangdahong' => 'hi@liangdahong.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/liangdahong/AMLeaksFinder.git', :tag => s.version}
s.source_files = 'AMLeaksFinder/**/*.{h,m}'
s.resource     = 'AMLeaksFinder/**/*.{bundle,xib}'
s.requires_arc = true
end
