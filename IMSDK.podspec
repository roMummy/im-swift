Pod::Spec.new do |s|
  s.name         = 'IMSDK'
  s.version      = '0.0.1'
  s.authors      = 'hd', { 'hd' => '' }
  s.homepage     = 'www.example.com'
  s.summary      = 'Simple packaging for ImageMagick.'
  s.description  = 'ImageMagick'
  s.source       = { :git => '.'}
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = "9.0"
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE',
    :text => 'Permission is hereby granted ...'
  }

  s.swift_version = '5.0'
#  s.source_files =  'IMSDK/*.{m,h,swift,modulemap}', 'IMSDK/Classes/*.{m,h,swift}'
  s.vendored_frameworks = '/Products/IMSDK.framework'
  s.frameworks = ['Magick']

  s.pod_target_xcconfig ={
'ENABLE_BITCODE' => 'NO',
'SWIFT_COMPILER_SEARCH_PATHS_IMPORT_PATHS' => '/IMSDK/'

}

end