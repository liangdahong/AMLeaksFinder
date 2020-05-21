Pod::Spec.new do |s|
s.name         = 'AMLeaksFinder'
s.version      = '1.1.0'
s.summary      = 'A small tool for automatically detecting the [controller memory leak] in the project'
s.homepage     = 'https://github.com/liangdahong/AMLeaksFinder'
s.license      = 'MIT'
s.authors      = {'梁大红' => 'ios@liangdahong.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/liangdahong/AMLeaksFinder.git', :tag => s.version}
s.source_files = 'Sources/**/*.{h,m}'
s.resources    = "Sources/**/*.{xib,nib,storyboard,png}"
s.requires_arc = true
end
