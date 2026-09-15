Pod::Spec.new do |s|
  s.name             = 'hg_native'
  s.version          = '0.1.0'
  s.summary          = 'Native SecureStore and OnDeviceAi for hg_flutter.'
  s.homepage         = 'https://github.com/example/hg_flutter'
  s.license          = { :type => 'MIT' }
  s.author           = { 'HGS' => 'dev@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version    = '5.0'
end
