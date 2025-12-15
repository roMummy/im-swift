# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'


target 'ImageMagickDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for IMSDK
  # 加载本地
  pod 'IMSDK', :path => '.'

  # 加载git地址
#  pod 'IMSDK', :git => 'https://github.com/roMummy/im-swift.git'
  post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
      end
    end
  end
end
