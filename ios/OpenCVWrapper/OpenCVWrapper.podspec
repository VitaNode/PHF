Pod::Spec.new do |s|
  s.name             = 'OpenCVWrapper'
  s.version          = '0.0.1'
  s.summary          = 'A local wrapper for OpenCV.'
  s.description      = <<-DESC
A local wrapper for OpenCV to use in Flutter Runner.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = '*.{h,mm}'
  s.public_header_files = '*.h'
  
  s.platform = :ios, '11.0'
  s.dependency 'OpenCV', '~> 4.3'
  s.static_framework = true
end
