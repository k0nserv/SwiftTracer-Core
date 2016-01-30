Pod::Spec.new do |spec|
  spec.name         = 'SwiftTracer-Core'
  spec.version      = '0.0.1'
  spec.license      = { type: 'MIT' }
  spec.homepage     = 'https://github.com/k0nserv/SwiftTracer-Core'
  spec.authors      = { 'Hugo Tunius' => 'h@tunius.se' }
  spec.summary      = 'SwiftTracer core rendering logic. OS independant'
  spec.source       = { git: 'https://github.com/k0nserv/SwiftTracer-Core.git', tag: spec.version }
  spec.source_files = 'Sources/*/*.swift'
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
end

