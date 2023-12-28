Pod::Spec.new do |s|
  s.name         = 'IMSDK'
  s.version      = '0.0.1'
  s.authors      = 'tw', { 'tw' => '' }
  s.homepage     = 'www.example.com'
  s.summary      = 'Simple packaging for ImageMagick.'
  s.description  = 'ImageMagick'
  s.source       = { :http => 'https://github.com/roMummy/im-swift/tree/main/IMSDK/Frameworks/IMSDK.xcframework'}
  s.platform     = :ios, '11.0'
  s.ios.deployment_target = "11.0"
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE',
    :text => 'Permission is hereby granted ...'
  }

  s.swift_version = '5.0'
  s.vendored_frameworks = 'Frameworks/IMSDK.xcframework'
  s.libraries = 'expat.1', 'xml2'

  s.xcconfig = {
   'OTHER_LDFLAGS' => '-ObjC -lz'
  }
  s.pod_target_xcconfig ={
	'ENABLE_BITCODE' => 'NO',
	'SWIFT_COMPILER_SEARCH_PATHS_IMPORT_PATHS' => '/IMSDK/'

  }

end