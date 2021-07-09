## ImageMagick

Github: https://github.com/ImageMagick/ImageMagick

官网：https://imagemagick.org/

demo：https://github.com/marforic/imagemagick_lib_iphone

发布版：https://download.imagemagick.org/ImageMagick/download/iOS/

例子：https://imagemagick.org/MagickWand/

#### 版本
ImageMagick: 7.1.0-0 Q8 arm 2021-06-02 https://imagemagick.org

#### 简介

使用 ImageMagick [®](http://tarr.uspto.gov/servlet/tarr?regser=serial&entry=78333969)创建、编辑、合成或转换数字图像。它可以读取和写入各种[格式](https://imagemagick.org/script/formats.php)（超过 200 种）的图像，包括 PNG、JPEG、GIF、WebP、HEIC、SVG、PDF、[DPX](https://imagemagick.org/script/motion-picture.php)、[EXR](https://imagemagick.org/script/high-dynamic-range.php)和 TIFF。ImageMagick 可以调整大小、翻转、镜像、旋转、扭曲、剪切和变换图像，调整图像颜色，应用各种特殊效果，或绘制文本、线条、多边形、椭圆和贝塞尔曲线。

#### 安装

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

**MagickCore**：底层的C语言接口。较复杂，但是可以修改很多参数

> API：https://imagemagick.org/api/MagickCore/index.html

**MagickWan**：推荐的C语言接口。相比于MagickCore接口，简单很多。

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



#### CLI

参考https://imagemagick.org/script/command-line-tools.php

##### Magick

等于 `convert`命令

##### [Convert](https://legacy.imagemagick.org/script/convert.php)

在图像格式之间转换以及调整图像大小、模糊、裁剪、去斑、抖动、绘制、翻转、连接、重新采样等等。

- 格式转换

  ```shell
  convert rose.jpg rose.png
  ```

   gif转jpg 会生成图片数组（frame-0.jpg, frame-1.jpg, frame-2.jpg ...）

  ```
  convert -coalesce  rain.gif  frame.jpg
  # -coalesce：根据图像 -dispose 元数据的设置覆盖图像序列中的每个图像，以重现动画序列中每个点的动画效果。
  ```

  如果想使用下划线作为符号，输出为 `frame_0.jpg, frame_1.jpg, frame_2.jpg ...`，则可以如下设置。

  ```
  convert  -coalesce  rain.gif  frame_%d.jpg
  ```

  如果只想拿到 GIF 的第一帧，可以这样设置。

  ```
  convert  -coalesce  'rain.gif[0]'  first_frame.jpg
  ```

  拿到某些帧，如同 `-clone` 的写法。

  ```
  convert  -coalesce  'rain.gif[0-2]'  some_frames_%d.jpg
  ```

- 缩放

  ```
  convert -resize '150x100!' goods.jpg thumbnail.jpg
  ```

- 设置质量

  ```
  # 0 - 100
  convert -quality 70 -strip goods.jpg thumbnail.jpg
  ```

  

- 油画

  ```shell
  convert rose:  -paint 5   rose_paint_5.gif
  ```

- 木炭

  ```
  convert rose:  -charcoal 1   rose_charcoal_1.gif
  ```

- 铅笔素描

  ```
  convert pagoda_sm.jpg -colorspace gray -sketch 0x20+120 sketch_new.gif
  ```

- 网格化

  ```
  convert rose: -background SkyBlue \    
  -crop 10x0 +repage -splice 3x0 +append \   
  -crop 0x10 +repage -splice 0x3 -append \   
  grid_tile.png
  ```

- 边缘检测

  ```
  convert piglet.gif -colorspace Gray \         
  -negate -edge 1 -negate    piglet_edge_neg.gif
  ```

  or

  ```
  convert rose:   -canny 0x1+10%+30%  rose_canny.gif
  ```

  

- 缩略图

  ```
   convert thumbnail.gif -bordercolor snow -background black +polaroid \ 
   poloroid_operator.png
  ```

- 设置dpi

  ```
   convert -density 90 input.gif  density.gif
  ```

  

- 反射

  ```
  convert pokemon.gif -alpha on \
  			( +clone -flip -channel A -evaluate multiply .35 +channel ) -append \
        -size 100x100 xc:black +swap \
        -gravity North -geometry +0+5 -composite  reflect_alpha.png
  ```

  

- 拼图

  ```
  convert input1.jpg input2.jpg +append output.jpg
  #+append 水平连接
  #-append 垂直连接
  ```

- ps

  ```
  # -fuzz 色差 -transparent 透明
  convert -fuzz 7%  -transparent #888888  input.jpg output.png
  ```

  



...



#### [Mogrify](https://legacy.imagemagick.org/script/mogrify.php)

convert的批量处理命令，不需要指定输出文件，自动覆盖原始图像文件。

#### [Composite](https://legacy.imagemagick.org/script/composite.php)

“ `composite`”命令专为以各种方式将两个图像简单地合成（叠加）在一起而设计。这包括限制图像组合在一起的区域，尽管使用第三个掩蔽图像。



#### [Montage](https://legacy.imagemagick.org/script/montage.php)

“ `montage`” 将开始根据当前的设置将图像列表处理成缩略图索引页放

#### [Identify](https://legacy.imagemagick.org/script/identify.php)

“identify”命令旨在以简单而有用的方式返回有关图像的信息。

* 打印图片信息

  ```
  identify  tree.gif
  ```

* 提取图像中颜色数量的计数

  ```
   identify -format '%k\n' tree.gif
  ```

   

  ...

#### [Compare](https://legacy.imagemagick.org/script/compare.php)

比较两个相似图片的不同点

```
compare bag_frame1.gif bag_frame2.gif  compare.gif
```

#### [Display](https://legacy.imagemagick.org/script/display.php)

 `display`程序旨在以循环幻灯片的形式显示图像或图像列表。

#### [Animate](https://legacy.imagemagick.org/script/animate.php)

与`display` 相似

#### [Stream](https://legacy.imagemagick.org/Usage/basics/#stream)

 `stream`是一种特殊程序，旨在处理提取超大图像文件的一部分

```
 stream -map rgb -storage-type char -extract 100x100+200+100 logo: - |\
    convert -depth 8 -size 100x100 rgb:-   stream_wand.gif
```

#### [Import](https://legacy.imagemagick.org/Usage/basics/#import)

从屏幕显示中读取图像



#### 注意

- 如果是使用颜色，比如 

  ```shell
  convert t0NeV0C.png -fuzz 20% -opaque '#888888' result.png
  ```

  不要使用`'#888888'` ,直接使用 `#888888` ,不然颜色不会被识别

  ```shell
  convert t0NeV0C.png -fuzz 20% -opaque #888888 result.png
  ```

  

#### TODO

- [x] 更换最新版ImageMagick

- [ ] 解决文字水印的问题（应该是font的问题， iOS上没有可用的font，目前不知道怎么配置字体）

