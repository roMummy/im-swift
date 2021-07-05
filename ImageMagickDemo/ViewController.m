//
//  ViewController.m
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/21.
//

#import "ViewController.h"

#import "IMSDK.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    NSLog(@"%s", GetMagickVersion(nil));
    
//    NSString * path = [[NSBundle mainBundle] resourcePath];
//    setenv("MAGICK_CONFIGURE_PATH", [path UTF8String], 1);
//    NSString * tempPath = [NSString stringWithFormat:@"%@Magick/",NSTemporaryDirectory()];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:tempPath withIntermediateDirectories:true attributes:nil error:nil];
//    }
//    setenv("MAGICK_TEMPORARY_PATH", [tempPath UTF8String], 1);
//    setenv("MAGICK_FONT_PATH", [path UTF8String], 1);
//    setenv("HOME", [path UTF8String], 1);
//
    
    self.inputPath = [[NSBundle mainBundle] pathForResource:@"shirt" ofType:@"jpg"];
    self.outputPath = [NSTemporaryDirectory() stringByAppendingString:@"output.png"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.outputPath error:nil];
    }
    NSLog(@"--input");
    
    self.originalImageView.image = [UIImage imageWithContentsOfFile:_inputPath];
    
    
    
    NSLog(@"--output");
//    [self getFileInfo:outputPath];
//    [self saveToPhotosAlbum:outputPath];
}

- (void)handleResult:(IMResult *)result {
    if (result.status == StatusSuccess) {
        NSLog(@"success");
        self.imageView.image = [UIImage imageWithContentsOfFile:self.outputPath];
    } else {
        NSLog(@"error - %@", result.errorMsg);
    }
}

- (IBAction)monochromeClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -monochrome %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)convertClick:(id)sender {
//    self.outputPath = [NSTemporaryDirectory() stringByAppendingString:@"output.pdf"];
    NSString *cmds = [NSString stringWithFormat:@"convert %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)thumbnailClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@" convert %@ -bordercolor snow -background black +polaroid \
                      %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)blurClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -blur 80 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)flipClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -flip %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)flopClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -flop %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
- (IBAction)negateClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -negate %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)noiseClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -noise 3 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)colorizeClick:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -colorize 255 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)implode:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -implode 1 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)solarize:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -solarize 42 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)spread:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -spread 5 %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)sample:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -sample 10%% -sample 1000%%  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)append:(id)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpg"];
    NSString *cmds = [NSString stringWithFormat:@"convert %@ %@ +append %@",self.inputPath, imagePath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}


- (IBAction)rotate:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -rotate 30  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}


- (IBAction)charcoal:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -charcoal 2  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)swirl:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -swirl 67  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}


- (IBAction)raise:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -raise 5x5  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

- (IBAction)imageMark:(id)sender {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpg"];
    IMResult *result = [IMHelper.shared addWatermarkWithMark:imagePath inputPath:self.inputPath outputPath:self.outputPath];
    [self handleResult:result];
}

- (IBAction)textMark:(id)sender {
    IMResult *result = [IMHelper.shared addWatermarkWithText:@"啦啦啦" textColor:[UIColor blackColor] inputPath:self.inputPath outputPath:self.outputPath];
    [self handleResult:result];
}
/// 换装
- (IBAction)cutout:(id)sender {
//    self.inputPath = [NSBundle.mainBundle pathForResource:@"shirt" ofType:@"jpg"];
    NSString *cmds1 = [NSString stringWithFormat:@"convert %@ -colorspace HSL -channel Hue -separate %@",self.inputPath, self.outputPath];
    
    [IMHelper.shared cliConvertWithCmds:cmds1];
    
    NSString *shirt_mask = self.outputPath;
    
    NSString *cmds2 = [NSString stringWithFormat:@"convert %@ -morphology Smooth Square \
                       -negate %@",shirt_mask, self.outputPath];
    [IMHelper.shared cliConvertWithCmds:cmds2];
    
    NSString *shirt_write_mask = self.outputPath;
    
    NSString *cmds3 = [NSString stringWithFormat:@"convert %@ -mask %@ \
                       -modulate 100,100,25    +mask %@",self.inputPath, shirt_write_mask, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds3];
    [self handleResult:result];
}
/// 油画效果
- (IBAction)paint:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert %@  -paint 5   %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
/// 铅笔
- (IBAction)sketch:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert %@   -colorspace gray -sketch 0x10+120   %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
/// 网格化
- (IBAction)reseau:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"  convert %@ -background SkyBlue \
                      -crop 10x0 +repage -splice 3x0 +append \
                      -crop 0x10 +repage -splice 0x3 -append \
                      %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
/// 边缘检测
- (IBAction)edge:(id)sender {
//     convert rose:              -canny 0x1+10%+30%  rose_canny.gif
    NSString *cmds = [NSString stringWithFormat:@" convert %@ -colorspace Gray \
                      -negate -edge 1 -negate    %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
/// 反射
- (IBAction)reflection:(id)sender {
    
    NSString *cmds = [NSString stringWithFormat:@"convert %@ -alpha on \
                     ( +clone -flip -channel A -evaluate multiply .35 +channel )  -append \
                      -size 200x700 xc:black +swap \
                      -gravity North -geometry +0+5 -composite  %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}
/// 设置dpi
- (IBAction)density:(id)sender {
    NSString *cmds = [NSString stringWithFormat:@"convert -density 100  %@ %@",self.inputPath, self.outputPath];
    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
    [self handleResult:result];
}

/// 简单抠图
- (IBAction)ps:(id)sender {

//    NSString *cmds = [NSString stringWithFormat:@"magick -debug all %@ -fuzz 7%%  -transparent #888888   %@",, self.outputPath];
//    IMResult *result = [IMHelper.shared cliConvertWithCmds:cmds];
//    [self handleResult:result];
    
    IMResult *result = [IMHelper.shared fuzzWithBgColor:UIColorFromRGB(0x888888) toColor:UIColorFromRGB(0x777777) inputPath:self.inputPath outputPath:self.outputPath];
   
    [self handleResult:result];
}



//- (NSData *)watermark:(NSString *)inputPath outputPath:(NSString *)outputPath text:(NSString *)text {
//
//    NSString *font = [[NSBundle mainBundle] pathForResource:@"OpenSans-Regular" ofType:@"ttf"];
//    char *fonts = "";
//    size_t number = 0;
//
//
//    MagickWand *wand = NULL;
//    DrawingWand *draw = NULL;
//    PixelWand *pixel = NULL;
//
//    MagickWandGenesis();
//
//
//
//    wand = NewMagickWand();
//    pixel = NewPixelWand();
//    draw = NewDrawingWand();
//
//    if (MagickReadImage(wand, [inputPath UTF8String]) == MagickFalse) {
//        NSLog(@"读取失败");
//        ThrowWandException(wand);
//    };
//    if (MagickSetFont(wand, font.UTF8String) == MagickFalse) {
//        NSLog(@"设置字体失败");
//    };
//    MagickQueryFonts(fonts, &number);
//    NSLog(@"font list： %@", [NSString stringWithCString:fonts encoding:NSUTF8StringEncoding]);
//
//    PixelSetColor(pixel, "red");
//    DrawSetFillColor(draw, pixel);
////    DrawSetFont(draw, font.UTF8String);
////    DrawSetFontSize(draw, 20);
//    DrawSetGravity(draw, CenterGravity);
//    DrawPoint(draw, 10, 10);
//
//    const unsigned char *str = "hhhhhhh";
//    DrawAnnotation(draw, 0, 0, str);
////    DrawComment(draw, str);
//
//    if (MagickDrawImage(wand, draw) == MagickFalse) {
//        ThrowWandException(wand);
//        ThrowDrawException(draw);
//    }
//
//    MagickSetImageCompressionQuality(wand, 85);
//    MagickSetImageFormat(wand, "png");
////    MagickWriteImage(wand, outputPath.UTF8String);
//
//    // write
//    size_t length = 0;
//    void * images = MagickGetImageBlob(wand, &length);
//
//    NSData *data = [NSData dataWithBytes:images length:length];
//
//    // clean
//    DestroyMagickWand(wand);
//    DestroyDrawingWand(draw);
//    DestroyPixelWand(pixel);
//    MagickRelinquishMemory(images);
//
//    MagickWandTerminus();
//
//    return data;
//}
//
//- (void)gifToJpg:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWand *magick_wand = NULL;
//    int status;
//    MagickWandGenesis();
//    NSArray *list = [outputPath componentsSeparatedByString:@"."];
//
//    /* 创建一个魔杖 */
//    magick_wand = NewMagickWand();
//
//    /* 读取输入图像 */
//    MagickReadImage(magick_wand, [inputPath UTF8String]);
//
////    NSLog(@"input - %s", MagickIdentifyImage(magick_wand));
//    /* 写下来 */
//    MagickResetIterator(magick_wand);
//    int i = 0;
//    while (MagickNextImage(magick_wand) != MagickFalse) {
//        NSString *path = [NSString stringWithFormat:@"%@%d.%@",list.firstObject,i,list.lastObject];
//        status = MagickWriteImage(magick_wand, path.UTF8String);
//        if (status == MagickFalse) { //写图片失败
//            magick_wand = DestroyMagickWand(magick_wand);
//            MagickWandTerminus();
//            return;
//        }
//        i ++;
//    }
//    /* clean */
//    if(magick_wand) magick_wand = DestroyMagickWand(magick_wand);
//
//    MagickWandTerminus();
//}
///// jpg to png
//- (void)conver:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWand *mw = NULL;
//
//    MagickWandGenesis();
//
//    /* 创建一个魔杖 */
//    mw = NewMagickWand();
//
//    /* 读取输入图像 */
//    MagickReadImage(mw, [inputPath UTF8String]);
//    /* 写下来 */
//    MagickWriteImage(mw, [outputPath UTF8String]);
//
//    /* clean */
//    if(mw) mw = DestroyMagickWand(mw);
//
//    MagickWandTerminus();
//}
//
///// 使用 Lanczos 滤镜将图像大小调整为 50% 并另存为高质量 图片
//- (void)resize:(NSString *)imageName outputPath:(NSString *)outputPath {
//    MagickWand *m_wand = NULL;
//
//    int width,height;
//
//    MagickWandGenesis();
//
//    m_wand = NewMagickWand();
//    // 读取图片
//    if (MagickReadImage(m_wand, [imageName UTF8String]) == MagickFalse) {
//        NSLog(@"文件读取失败");
//        return;
//    }
//
//    // 获取图片宽高
//    width = MagickGetImageWidth(m_wand);
//    height = MagickGetImageHeight(m_wand);
//
//    // 将它们切成两半，但要确保它们不会下溢
//    if((width /= 2) < 1)width = 1;
//    if((height /= 2) < 1)height = 1;
//
//    // 使用 Lanczos 滤镜调整图像大小
//    // 模糊因子是“双倍”，其中 > 1 表示模糊，< 1 表示清晰
//    MagickResizeImage(m_wand,width,height,LanczosFilter,1);
//
//    // 将压缩质量设置为 95（高质量 = 低压缩）
//    MagickSetImageCompressionQuality(m_wand,80);
//
//    // 写入
//    MagickWriteImage(m_wand, [outputPath UTF8String]);
//
//    // clean
//    if(m_wand)m_wand = DestroyMagickWand(m_wand);
//
//    MagickWandTerminus();
//}
///// 添加背景
//- (NSData *)addCanvas:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    NSString *font = [[NSBundle mainBundle] pathForResource:@"OpenSans-Regular" ofType:@"ttf"];
//
//    MagickWand *m_wand = NULL;
//    DrawingWand *draw = NULL;
//    PixelWand *p_wand;
//    int w,h;
//
//    MagickWandGenesis();
//
//    /* Create a wand */
//    m_wand = NewMagickWand();
//    p_wand = NewPixelWand();
//    draw = NewDrawingWand();
//
//    // Change this to whatever colour you like - e.g. "none"
//    PixelSetColor(p_wand, "blue");
//
//    /* Read the input image */
//    MagickReadImage(m_wand, [inputPath UTF8String]);
//
//    DrawSetFillColor(draw, p_wand);
//    DrawSetFont(draw, [font UTF8String]);
//    DrawSetFontSize(draw, 100);
//    DrawSetGravity(draw, CenterGravity);
//    DrawAnnotation(draw, 0, 0, "快乐风男");
//    MagickDrawImage(m_wand, draw);
//
//    w = MagickGetImageWidth(m_wand);
//    h = MagickGetImageHeight(m_wand);
//    MagickSetImageBackgroundColor(m_wand,p_wand);
//    // This centres the original image on the new canvas.
//    // Note that the extent's offset is relative to the
//    // top left corner of the *original* image, so adding an extent
//    // around it means that the offset will be negative
//    MagickExtentImage(m_wand,1024,768,-(1024-w)/2,-(768-h)/2);
//    MagickWriteImage(m_wand,[outputPath UTF8String]);
//
//    size_t length = 0;
//    void * images = MagickGetImageBlob(m_wand, &length);
//
//    NSData *data = [NSData dataWithBytes:images length:length];
//
//    /* Tidy up */
//    m_wand = DestroyMagickWand(m_wand);
//    p_wand = DestroyPixelWand(p_wand);
//    MagickWandTerminus();
//
//    return data;
//
//}
///// 把白色背景设置成透明
//- (void)transparent:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWand *m_wand = NULL;
//    PixelWand *fc_wand = NULL;
//    PixelWand *bc_wand = NULL;
//    ChannelType channel;
//
//
//    MagickWandGenesis();
//    m_wand = NewMagickWand();
//    // PixelWands for the fill and bordercolour
//    fc_wand = NewPixelWand();
//    bc_wand = NewPixelWand();
//
//    MagickReadImage(m_wand,[inputPath UTF8String]);
//
//    PixelSetColor(fc_wand,"none");
//
//    PixelSetColor(bc_wand,"white");
//
//    // Convert "rgba" to the enumerated ChannelType required by the floodfill function
//    channel = ParseChannelOption("rgba");
//
//    //    The bordercolor=bc_wand (with fuzz of 20 applied) is replaced
//    // by the fill colour=fc_wand starting at the given coordinate - in this case 0,0.
//    // Normally the last argument is MagickFalse so that the colours are matched but
//    // if it is MagickTrue then it floodfills any pixel that does *not* match
//    // the target color
//    MagickFloodfillPaintImage(m_wand,channel,fc_wand,20,bc_wand,0,0,MagickFalse);
//
//    MagickWriteImage(m_wand,[outputPath UTF8String]);
//
//    /* and we're done so destroy the magick wand etc.*/
//    fc_wand = DestroyPixelWand(fc_wand);
//    bc_wand = DestroyPixelWand(bc_wand);
//    m_wand = DestroyMagickWand(m_wand);
//    MagickWandTerminus();
//}
//
//- (void)image2DTo3D:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWand *image = NULL, *canvas = NULL;
//    DrawingWand *line = NULL;
//    PixelWand *pw = NULL;
//
//    int w,h;
//    int r,g,b,grey,offset;
//    int start_y,end_y;
//    int x,y;
//    int line_height;
//    char *url,*file;
//
//    MagickWandGenesis();
//    // input image
//// The input image is at: "http://eclecticdjs.com/mike/temp/ball/fract6.jpg"
//    url = [inputPath UTF8String];
//    // output image
//    file = [outputPath UTF8String];
////    file = "3d_fractal.jpg";
//
//
//    image = NewMagickWand();
//    pw = NewPixelWand();
//
//    MagickReadImage(image,url);
//    // scale it down
//    w = (int) MagickGetImageWidth(image);
//    h = (int) MagickGetImageHeight(image);
//
//    PixelSetColor(pw,"transparent");
//    if(MagickShearImage(image,pw,45,0) == MagickFalse) {
//        NSLog(@"MagickShearImage fail");
//    }
//
//    w = (int) MagickGetImageWidth(image);
//    h = (int) MagickGetImageHeight(image);
//
//    // scale it to make it look like it is laying down
//    if(MagickScaleImage(image,w,h/2) == MagickFalse) {
//        NSLog(@"MagickScaleImage fail");
//    }
//
////        MessageBox(NULL,"C - Scale failed","",MB_OK);
//    // Get image stats
//    w = (int) MagickGetImageWidth(image);
//    h = (int) MagickGetImageHeight(image);
//
//    // Make a blank canvas to draw on
//    canvas = NewMagickWand();
//    // Use a colour from the input image
//    MagickGetImagePixelColor(image,0,0,pw);
//    MagickNewImage(canvas,w,h*2,pw);
//
//    offset = h;
//// The original drawing method was to go along each row from top to bottom so that
//// a line in the "front" (which is one lower down the picture) will be drawn over
//// one behind it.
//// The problem with this method is that every line is drawn even if it will be covered
//// up by a line "in front" of it later on.
//// The method used here goes up each column from left to right and only draws a line if
//// it is longer than everything drawn so far in this column and will therefore be visible.
//// With the new drawing method this takes 13 secs - the previous method took 59 secs
//    // loop through all points in image
//    for(x=0;x<w;x++) {
//        // The PHP version created, used and destroyed the drawingwand inside
//        // the inner loop but it is about 25% faster to do only the DrawLine
//        // inside the loop
//        line = NewDrawingWand();
//        line_height = 0;
//        for(y=h-1;y>=0;y--) {
//            // get (r,g,b) and grey value
//            if(MagickGetImagePixelColor(image,x,y,pw) == MagickFalse)continue;
//            // 255* adjusts the rgb values to Q8 even if the IM being used is Q16
//            r = (int) (255*PixelGetRed(pw));
//            g = (int) (255*PixelGetGreen(pw));
//            b = (int) (255*PixelGetBlue(pw));
//
//            // Calculate grayscale - a divisor of 10-25 seems to work well.
////            grey = (r+g+b)/25;
//            grey = (r+g+b)/15;
////            grey = (r+g+b)/10;
//            // Only draw a line if it will show "above" what's already been done
//            if(line_height == 0 || line_height < grey) {
//                DrawSetFillColor(line,pw);
//                DrawSetStrokeColor(line,pw);
//                // Draw the part of the line that is visible
//                start_y = y+offset - line_height;
//                end_y = y-grey+offset;
//                DrawLine(line,x,start_y,x,end_y);
//                line_height = grey;
//            }
//            line_height--;
//        }
//        // Draw the lines on the image
//        if (MagickDrawImage(canvas,line) == MagickFalse) {
//            NSLog(@"lines fail");
//        } ;
//        DestroyDrawingWand(line);
//    }
//    MagickScaleImage(canvas,w-h,h*2);
//    // write canvas
//    MagickWriteImage(canvas,file);
//    // clean up
//    DestroyMagickWand(canvas);
//    DestroyMagickWand(image);
//    DestroyPixelWand(pw);
//    MagickWandTerminus();
//}
///// 给已清除的帧动画添加静态背景
//- (void)addStaticBackgroundToFrameAnimation:(NSString *)animationPath bgPath:(NSString *)bgPath outputPath:(NSString *)outputPath {
//    MagickWand *mw = NULL;
//    MagickWand *aw = NULL;
//    MagickWand *tw = NULL;
//    unsigned int i;
//
//    MagickWandGenesis();
//
//    /* Create a wand */
//    mw = NewMagickWand();
//
//    /* Read the first input image */
//    if(MagickReadImage(mw,[bgPath UTF8String]) == MagickFalse) {
//        NSLog(@"MagickReadImage fail");
//    }
//
////( bunny_anim.gif -repage 0x0+5+15\! )
//    // We need a separate wand to do this bit in parentheses
//    aw = NewMagickWand();
//    if(MagickReadImage(aw,[animationPath UTF8String])) {
//        NSLog(@"MagickReadImage fail");
//    }
//    MagickResetImagePage(aw,"0x0+5+15!");
//
//    // Now we have to add the images in the aw wand on to the end
//    // of the mw wand.
//    MagickAddImage(mw,aw);
//    // We can now destroy the aw wand so that it can be used
//    // for the next operation
//    if(aw) aw = DestroyMagickWand(aw);
//
//// -coalesce
//    aw = MagickCoalesceImages(mw);
//
//// do "-delete 0" by copying the images from the "aw" wand to
//// the "mw" wand but omit the first one
//    // free up the mw wand and recreate it for this step
//    if(mw) mw = DestroyMagickWand(mw);
//    mw = NewMagickWand();
//    for(i=1;i<MagickGetNumberImages(aw);i++) {
//        MagickSetIteratorIndex(aw,i);
//        tw = MagickGetImage(aw);
//        MagickAddImage(mw,tw);
//        DestroyMagickWand(tw);
//    }
//    MagickResetIterator(mw);
//
//    // free up aw for the next step
//    if(aw) aw = DestroyMagickWand(aw);
//
//// -deconstruct
//// Anthony says that MagickDeconstructImages is equivalent
//// to MagickCompareImagesLayers so we'll use that
//
//    aw = MagickCompareImageLayers(mw,CompareAnyLayer);
//
//// -loop 0
//    MagickSetOption(aw,"loop","0");
//
//    /* write the images into one file */
//
////    size_t length = 0;
////    void * images = MagickGetImageBlob(aw, &length);
////
////    NSData *data = [NSData dataWithBytes:images length:length];
//
//    if(MagickWriteImages(aw,[outputPath UTF8String],MagickTrue)) {
//        NSLog(@"MagickWriteImages fail");
//    }
//
//    /* Tidy up - note that the "tw" wand has already been destroyed */
//    if(mw) mw = DestroyMagickWand(mw);
//    if(aw) aw = DestroyMagickWand(aw);
//    MagickWandTerminus();
//
////    return data;
//}
///// 反射图片
//- (void)reflectionImage:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWand *mw = NULL,
//            // Reflection wand
//            *mwr = NULL,
//            // gradient wand
//            *mwg = NULL;
//    int w,h;
//
//    MagickWandGenesis();
//    mw = NewMagickWand();
//    MagickReadImage(mw,[inputPath UTF8String]);
//    // We know that logo: is 640x480 but in the general case
//    // we need to get the dimensions of the image
//    w = MagickGetImageWidth(mw);
//    h = MagickGetImageHeight(mw);
//
//    // +matte is the same as -alpha off
//    // This does it the "new" way but if your IM doesn't have this
//    // then MagickSetImageMatte(mw,MagickFalse); can be used
//    // MagickSetImageAlphaChannel(mw,DeactivateAlphaChannel);
//    MagickSetImageMatte(mw,MagickFalse);
//    // clone the input image
//    mwr = CloneMagickWand(mw);
//    // Resize it
//    MagickResizeImage(mwr,w,h/2,LanczosFilter,1);
//    // Flip the image over to form the reflection
//    MagickFlipImage(mwr);
//    // Create the gradient image which will be used as the alpha
//    // channel in the reflection image
//    mwg = NewMagickWand();
//    MagickSetSize(mwg,w,h/2);
//    MagickReadImage(mwg,"gradient:white-black");
//
//    // Copy the gradient in to the alpha channel of the reflection image
//    MagickCompositeImage(mwr,mwg,CopyOpacityCompositeOp,0,0);
//
//    // Add the reflection image to the wand which holds the original image
//    MagickAddImage(mw,mwr);
//    // Destroy and reuse mwg as the result image after the appen
//    if(mwg) mwg = DestroyMagickWand(mwg);
//
//    // Append the reflection to the bottom (MagickTrue) of the original image
//    mwg = MagickAppendImages(mw,MagickTrue);
//
//    // and save the result
//    MagickWriteImage(mwg,[outputPath UTF8String]);
//    if(mw) mw = DestroyMagickWand(mw);
//    if(mwg) mwg = DestroyMagickWand(mwg);
//    if(mwr) mwr = DestroyMagickWand(mwr);
//    MagickWandTerminus();
//}
//
//- (void)test:(NSString *)inputPath outputPath:(NSString *)outputPath {
//    MagickWandGenesis();
//    MagickWand *wand = NewMagickWand();
//    MagickReadImage(wand, inputPath.UTF8String);
//
//    ImageInfo *image_info = AcquireImageInfo();
//    ExceptionInfo *exception = AcquireExceptionInfo();
//
//    char *input_image = strdup([inputPath UTF8String]);
//    char *output_image = strdup([outputPath UTF8String]);
//
//    char *argv[] = { "convert", input_image, output_image, NULL };
//
//    MagickBooleanType status = ConvertImageCommand(image_info, 2, argv, NULL, exception);
//
//    free(input_image);
//    free(output_image);
//
//    if (exception->severity != UndefinedException)
//    {
//        status = MagickTrue;
//        CatchException(exception);
//    }
//
//    if (status == MagickFalse)
//    {
//        NSLog(@"FAIL");
//    }
//
//    size_t my_size;
//    unsigned char * my_image = MagickGetImageBlob(wand, &my_size);
//    NSData *outData = [[NSData alloc] initWithBytes:my_image length:my_size];
//    free(my_image);
//
//    self.imageView.image = [[UIImage alloc] initWithData:outData];
//
//    image_info=DestroyImageInfo(image_info);
//    exception=DestroyExceptionInfo(exception);
//    DestroyMagickWand(wand);
//    MagickWandTerminus();
//}
//
//- (NSData *)draw:(NSString *)outputPath {
//    MagickWand *m_wand = NULL;
//    DrawingWand *d_wand = NULL;
//    PixelWand *c_wand = NULL;
//    unsigned long radius,diameter;
//
//    diameter = 640;
//    radius = diameter/2;
//
//    MagickWandGenesis();
//
//    m_wand = NewMagickWand();
//    d_wand = NewDrawingWand();
//    c_wand = NewPixelWand();
//
//    PixelSetColor(c_wand,"white");
//    MagickNewImage(m_wand,diameter,diameter,c_wand);
//
//    DrawSetStrokeOpacity(d_wand,1);
//
//// 圆形和矩形
//PushDrawingWand(d_wand);
//// 嗯嗯。很奇怪。rgb(0,0,1) 在边缘周围画一条黑线
//// 应该是圆的。但是 rgb(0,0,0) 或 black 没有。
//// AND 如果我删除 PixelSetColor 那么它会绘制一个白色边界
//// 围绕矩形（大概也是围绕圆形）
//    PixelSetColor(c_wand,"rgb(0,0,1)");
//
//    DrawSetStrokeColor(d_wand,c_wand);
//    DrawSetStrokeWidth(d_wand,4);
//    DrawSetStrokeAntialias(d_wand,1);
//    PixelSetColor(c_wand,"red");
//    //DrawSetStrokeOpacity(d_wand,1);
//    DrawSetFillColor(d_wand,c_wand);
//
//    DrawCircle(d_wand,radius,radius,radius,radius*2);
//    DrawRectangle(d_wand,50,13,120,87);
//PopDrawingWand(d_wand);
//
//// 圆角矩形
//PushDrawingWand(d_wand);
//      {
//        const PointInfo points[37] =
//        {
//          { 378.1,81.72 }, { 381.1,79.56 }, { 384.3,78.12 }, { 387.6,77.33 },
//          { 391.1,77.11 }, { 394.6,77.62 }, { 397.8,78.77 }, { 400.9,80.57 },
//          { 403.6,83.02 }, { 523.9,216.8 }, { 526.2,219.7 }, { 527.6,223 },
//          { 528.4,226.4 }, { 528.6,229.8 }, { 528,233.3 }, { 526.9,236.5 },
//          { 525.1,239.5 }, { 522.6,242.2 }, { 495.9,266.3 }, { 493,268.5 },
//          { 489.7,269.9 }, { 486.4,270.8 }, { 482.9,270.9 }, { 479.5,270.4 },
//          { 476.2,269.3 }, { 473.2,267.5 }, { 470.4,265 }, { 350,131.2 },
//          { 347.8,128.3 }, { 346.4,125.1 }, { 345.6,121.7 }, {345.4,118.2 },
//          { 346,114.8 }, { 347.1,111.5 }, { 348.9,108.5 }, { 351.4,105.8 },
//          { 378.1,81.72 }
//        };
//
//        DrawSetStrokeAntialias(d_wand,MagickTrue);
//        DrawSetStrokeWidth(d_wand,2.016);
//        DrawSetStrokeLineCap(d_wand,RoundCap);
//        DrawSetStrokeLineJoin(d_wand,RoundJoin);
//        (void) DrawSetStrokeDashArray(d_wand,0,(const double *)NULL);
//
//        (void) PixelSetColor(c_wand,/*"#000080"*/"rgb(0,0,128)");
//        /* 如果strokecolor被完全移除，那么圆就不存在*/
//        DrawSetStrokeColor(d_wand,c_wand);
//        /* 但现在我添加了描边透明度 - 1=circle there 0=circle not there */
//        /* 如果不透明度为 1，则矩形周围的黑色边缘可见 */
//        DrawSetStrokeOpacity(d_wand,1);
//        /* 没有效果 */
//// DrawSetFillRule(d_wand,EvenOddRule);
//        /* 这不会影响圆 */
//        (void) PixelSetColor(c_wand,"#c2c280"/*"rgb(194,194,128)"*/);
//        DrawSetFillColor(d_wand,c_wand);
//        //1=圆那里 0=圆那里但矩形填充消失
//// DrawSetFillOpacity(d_wand,0);
//        DrawPolygon(d_wand,37,points);
//// DrawSetStrokeOpacity(d_wand,1);
//      }
//PopDrawingWand(d_wand);
//
//
///* 黄色多边形 */
//PushDrawingWand(d_wand);
//      {
//        const PointInfo points[15] =
//        {
//          { 540,288 }, { 561.6,216 }, { 547.2,43.2 }, { 280.8,36 },
//          { 302.4,194.4 }, { 331.2,64.8 }, { 504,64.8 }, { 475.2,115.2 },
//          { 525.6,93.6 }, { 496.8,158.4 }, { 532.8,136.8 }, { 518.4,180 },
//          { 540,172.8 }, { 540,223.2 }, { 540,288 }
//        };
//
//        DrawSetStrokeAntialias(d_wand,MagickTrue);
//        DrawSetStrokeWidth(d_wand,5.976);
//        DrawSetStrokeLineCap(d_wand,RoundCap);
//        DrawSetStrokeLineJoin(d_wand,RoundJoin);
//        (void) DrawSetStrokeDashArray(d_wand,0,(const double *)NULL);
//        (void) PixelSetColor(c_wand,"#4000c2");
//        DrawSetStrokeColor(d_wand,c_wand);
//        DrawSetFillRule(d_wand,EvenOddRule);
//        (void) PixelSetColor(c_wand,"#ffff00");
//        DrawSetFillColor(d_wand,c_wand);
//        DrawPolygon(d_wand,15,points);
//      }
//PopDrawingWand(d_wand);
//
//// 旋转和平移的椭圆
//// DrawEllipse 函数只绘制椭圆
//// 长轴和短轴正交对齐。这也是
//// 适用于其他一些函数，例如 DrawRectangle。
//// 如果你想要一个长轴旋转的椭圆，你
//// 必须在椭圆之前旋转坐标系
//// 画。而且你还需要椭圆的某个地方
//// 图像而不是左上角（0,0 原点所在的位置）
////定位）所以在绘制椭圆之前，我们将原点移动到
//// 我们希望椭圆的中心在哪里，然后
//// 将坐标系旋转我们希望的旋转角度
//// 应用于椭圆，然后*我们绘制椭圆。
//// 请注意，在 PushDrawingWand()/PopDrawingWand() 中执行所有这些操作
//// 表示坐标系将在之后恢复
//// PopDrawingWand
//PushDrawingWand(d_wand);
//
//    PixelSetColor(c_wand,"rgb(0,0,1)");
//
//    DrawSetStrokeColor(d_wand,c_wand);
//    DrawSetStrokeWidth(d_wand,2);
//    DrawSetStrokeAntialias(d_wand,1);
//    PixelSetColor(c_wand,"orange");
//    //DrawSetStrokeOpacity(d_wand,1);
//    DrawSetFillColor(d_wand,c_wand);
//    // 注意你干预的顺序
//    // 坐标系！旋转然后平移是
//    // 与平移然后旋转不同
//    DrawTranslate(d_wand,radius/2,3*radius/2);
//    DrawRotate(d_wand,-30);
//    DrawEllipse(d_wand,0,0,radius/8,3*radius/8,0,360);
//
//PopDrawingWand(d_wand);
//
//    // 从圆心开始的一条线
//    // 到图像的左上角
//    DrawLine(d_wand,0,0,radius,radius);
//
//    if (MagickDrawImage(m_wand,d_wand) == MagickFalse) {
//        ThrowWandException(m_wand);
//    };
//    MagickSetImageCompressionQuality(m_wand, 85);
//    MagickSetImageFormat(m_wand, "jpg");
////    MagickWriteImage(m_wand, outputPath.UTF8String);
//    NSData *data = [self wandToData:m_wand];
//
//    c_wand = DestroyPixelWand(c_wand);
//    m_wand = DestroyMagickWand(m_wand);
//    d_wand = DestroyDrawingWand(d_wand);
//
//    MagickWandTerminus();
//
//    return data;
//}
//
//- (NSData *)wandToData:(MagickWand *)wand {
//    // write
//    size_t length = 0;
//    void * images = MagickGetImageBlob(wand, &length);
//
//    NSData *data = [NSData dataWithBytes:images length:length];
//    return data;
//}
//
//- (void)convertImageCommand:(NSString *)command {
//    ImageInfo *imageInfo = NULL;
//    char * metaStr = AcquireString("");
//    MagickExceptionInfo * ext = AcquireExceptionInfo();
////    CompositeImageCommand(imageInfo, 0, [command UTF8String], &metaStr, ext);
//
//
//    char **argv;
//
//    MagickCoreGenesis(argv[0],MagickFalse);
//
//      {
//        MagickBooleanType status;
//
//        ImageInfo *image_info = AcquireImageInfo();
//        ExceptionInfo *exception = AcquireExceptionInfo();
//
//        int arg_count;
//        char *args[] = { "convert", "-size", "100x100", "xc:red",
//                         "(", "rose:", "-rotate", "-90", ")",
//                         "+append", "show:", NULL };
//        for(arg_count = 0; args[arg_count] != (char *)NULL; arg_count++);
//
//            ConvertImageCommand(image_info, arg_count, args, NULL, exception);
//
//            if (exception->severity != UndefinedException)
//            {
//              CatchException(exception);
//              fprintf(stderr, "Major Error Detected\n");
//            }
//
//        image_info=DestroyImageInfo(image_info);
//        exception=DestroyExceptionInfo(exception);
//      }
//      MagickCoreTerminus();
//}
//
///// convert photo.png -posterize 6 photo2.png
//- (NSData *)conver:(UIImage *)originalImage {
//    MagickWandGenesis();
//
//    MagickWand *wand = NewMagickWand();
//    NSData *data = UIImagePNGRepresentation(originalImage);
//    MagickReadImageBlob(wand, [data bytes], [data length]);
//
//    MagickBooleanType status;
//
//    status = MagickPosterizeImage(wand,6,MagickFalse);
//    if (status == MagickFalse)
//    {
//        NSLog(@"FAIL");
//    }
//
//    // Convert wand back to UIImage
//    unsigned char * c_blob;
//    size_t data_length;
//    c_blob = MagickGetImageBlob(wand,&data_length);
//    data = [NSData dataWithBytes:c_blob length:data_length];
//
//    DestroyMagickWand(wand);
//    MagickWandTerminus();
//
//    return data;
//}
//
//void ThrowWandException(MagickWand *wand)
//{ char
//  *description;
//
//  ExceptionType
//  severity;
//
//  description=MagickGetException(wand,&severity);
//  (void) fprintf(stderr,"%s %s %lu %s\n",GetMagickModule(),description);
//  description=(char *) MagickRelinquishMemory(description);
//}
//
//void ThrowDrawException(DrawingWand *wand)
//{ char
//  *description;
//
//  ExceptionType
//  severity;
//
//    ExceptionType type = DrawGetExceptionType(wand);
//  description=DrawGetException(wand, &severity);
//    (void) fprintf(stderr,"%s %s %lu %s --%u\n",GetMagickModule(),description,type);
//  description=(char *) MagickRelinquishMemory(description);
//}
//
//- (void)saveToPhotosAlbum:(NSString *)path {
//    UIImage * image = [UIImage imageWithContentsOfFile:path];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//}
//
//- (void)getFileInfo:(NSString *)path {
//    NSError *error = nil;
//    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
//    if (fileAttributes) {
//        NSNumber *fileSize;
//        NSString *fileOwner, *creationDate;
//        NSDate *fileModDate;
//        //文件大小
//        if ((fileSize = [fileAttributes objectForKey:NSFileSize])) {
//            NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
//        }
//        //文件创建日期
//        if ((creationDate = [fileAttributes objectForKey:NSFileCreationDate])) {
//            NSLog(@"File creationDate: %@\n", creationDate);
//        }
//        //文件所有者
//        if ((fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName])) {
//            NSLog(@"Owner: %@\n", fileOwner);
//        }
//        //文件修改日期
//        if ((fileModDate = [fileAttributes objectForKey:NSFileModificationDate])) {
//            NSLog(@"Modification date: %@\n", fileModDate);
//        }
//    }
//}

@end
