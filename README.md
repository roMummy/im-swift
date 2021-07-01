## ImageMagick

Github: https://github.com/ImageMagick/ImageMagick

官网：https://imagemagick.org/

demo：https://github.com/marforic/imagemagick_lib_iphone

发布版：https://download.imagemagick.org/ImageMagick/download/iOS/

例子：https://imagemagick.org/MagickWand/



**最后的版本是6.8.8-9**  

最后更新时间2014-06-14

#### 简介

使用 ImageMagick [®](http://tarr.uspto.gov/servlet/tarr?regser=serial&entry=78333969)创建、编辑、合成或转换数字图像。它可以读取和写入各种[格式](https://imagemagick.org/script/formats.php)（超过 200 种）的图像，包括 PNG、JPEG、GIF、WebP、HEIC、SVG、PDF、[DPX](https://imagemagick.org/script/motion-picture.php)、[EXR](https://imagemagick.org/script/high-dynamic-range.php)和 TIFF。ImageMagick 可以调整大小、翻转、镜像、旋转、扭曲、剪切和变换图像，调整图像颜色，应用各种特殊效果，或绘制文本、线条、多边形、椭圆和贝塞尔曲线。

#### 安装

* cocoapods

  > pod 'ImageMagick', '~> 6.8.8-9'

* 源码导入

  > 1、直接拖入iOSMagick-6.8.8-9-libs文件夹
  >
  > 2、Link Binary With Libraries 导入libxml2.tbd
  >
  > 3、设置OTHER_CFLAGS值为-Dmacintosh=1
  >
  > 4、设置Header Search Paths: $(SRCROOT) 递归查询(Recursive)
  >
  > 5、设置Library Search Paths: $(SRCROOT)递归查询(Recursive)
  >
  > 6、设置Enable Bitcode 为NO

#### 使用

**MagickCore：**底层的C语言接口。较复杂，但是可以修改很多参数

> API：https://imagemagick.org/api/MagickCore/index.html

**MagickWand：**推荐的C语言接口。相比于MagickCore接口，简单很多。

> API: https://imagemagick.org/api/MagickWand/index.html

**Magick++**: 提供面向对象的C++接口。

> API: https://imagemagick.org/api/Magick++/index.html



* 格式转换

  ```swift
  let inputPath = Bundle.main.path(forResource: "wizard", ofType: "jpg")
  let outputPath = NSTemporaryDirectory() + "out.jpg"
  let result = IMHelper.shared.conver(inputPath: inputPath, outputPath: outputPath)
  if result.status == .success {
     print("success")
  } else {
     print("fail - \(result.errorMsg ?? "")")
  }
  ```
  
* 图片压缩

  ```swift
  let inputPath = Bundle.main.path(forResource: "wizard", ofType: "jpg")
  let outputPath = NSTemporaryDirectory() + "out.jpg"
  let result = let result = IMHelper.shared.compress(image: inputPath!, quality: 10, resize: CGSize(width: 200, height: 200), outputPath: outputPath)
  if result.status == .success {
     print("success")
  } else {
     print("fail - \(result.errorMsg ?? "")")
  }
  ```
  
* 设置图片水印

  ```swift
  let inputPath = Bundle.main.path(forResource: "wizard", ofType: "jpg")
  let outputPath = NSTemporaryDirectory() + "out.jpg"
  let result = IMHelper.shared.addWatermark(mark: markPath!, inputPath: inputPath!, outputPath: outputPath)
  if result.status == .success {
     print("success")
  } else {
     print("fail - \(result.errorMsg ?? "")")
  }
  ```
  
* 图片裁剪

  ```swift
  	let result = IMHelper.shared.crop(image: inputPath!, size: CGSize(width: 100, height: 30), point: CGPoint(x: 0, y: 0), outputPath: outputPath)
  ```

* 使用cli的方式处理图片

  ```swift
  let cmd = """
      montage -background 'red' -geometry +4+4 \(inputPath!) \(markPath!) \(outputPath)
  		"""
  let result = IMHelper.shared.cilMontage(cmds: cmd)
  if result.status == .success {
     print("success")
  } else {
     print("fail - \(result.errorMsg ?? "")")
  }
  ```



#### TODO

- [ ] 更换最新版ImageMagick
- [ ] 解决文字水印的问题（应该是font的问题， iOS上没有可用的font，目前不知道怎么配置字体）

