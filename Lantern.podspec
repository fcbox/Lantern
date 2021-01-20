
Pod::Spec.new do |s|
    s.name             = 'Lantern'
    s.version          = '1.1.1'
    s.summary          = 'Elegant photo and video browser in Swift.'
    s.description      = 'Elegant photo and video browser in Swift. Inspired by WeChat.'
    
    s.homepage         = 'https://github.com/fcbox/Lantern'
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'JiongXing' => 'liangjiongxing@qq.com' }
    s.source           = { :git => 'https://github.com/fcbox/Lantern.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    s.swift_version = '4.2', '5.0'
    s.source_files = 'Sources/Lantern/*'
    
end
