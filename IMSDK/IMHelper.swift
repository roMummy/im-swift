//
//  IMHelper.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import UIKit
import Magick

public class IMHelper: NSObject {
    @objc
    public static let shared = IMHelper()
    override private init() {
        let version = GetMagickVersion(nil)
        print("[IM] version - \(String(cString: version!))")
        
        // 设置配置文件路径
        let mainPath = Bundle.init(for: Self.self).resourcePath
        if let path = mainPath {
            setenv("MAGICK_CONFIGURE_PATH", path.toUnsafeMutablePointer(), 1)
        }

        // 设置缓存文件路径
        let tempPath = NSTemporaryDirectory() + "Magick/"
       
        if !File.isExist(atPath: tempPath) {
            try? File.createDirectory(atPath: tempPath)
        }
        setenv("MAGICK_TEMPORARY_PATH", tempPath.toUnsafeMutablePointer(), 1)
    }
    
    // MARK: - public
    
    /// 格式转换
    /// 如果是gif -> jpg 会生成多个文件outut-0.jpg、output-1.jpg ...
    @objc
    public func conver(inputPath: String, outputPath: String) -> IMResult {
        let cmds =
            """
            convert \(inputPath) \(outputPath)
            """
        return cliConvert(cmds:cmds)
    }
    
    /// 添加图片水印
    @objc
    public func addWatermark(mark imagePath: String, inputPath: String, outputPath: String) -> IMResult {
        let cmds =
            """
            composite -dissolve 15 -tile \(imagePath) \(inputPath) \(outputPath)
            """
        return cliComposite(cmds:cmds)
    }
    
    /// 添加文字水印
    /// - Parameters:
    ///   - text: 文字
    ///   - textColor: 颜色
    ///   - inputPath: 输入路径
    ///   - outputPath: 输出路径
    /// - Returns: result
    @objc
    public func addWatermark(text: String, textColor: UIColor, inputPath: String, outputPath: String) -> IMResult? {
        // text to image
        guard let image = text.toImage(textColor: textColor) else {
            return nil
        }
        // save to temp dir
        let path = NSTemporaryDirectory() + "text_temp.png"
        
        if let data = image.pngData() {
            let url = URL(fileURLWithPath: path)
            try? data.write(to: url)
            return addWatermark(mark: path, inputPath: inputPath, outputPath: outputPath)
        }
        return nil
    }
    
    
    /// 图片裁剪
    /// size: 图片大小
    /// point: 开始位置
    @objc
    public func crop(image path: String, size: CGSize, point: CGPoint, outputPath: String) -> IMResult {
        let cmds =
            """
            convert \(path) -crop \(size.width)x\(size.height)+\(point.x)+\(point.y) \(outputPath)
            """
        return cliConvert(cmds:cmds)
    }
    
    /// 压缩图片
    /// - Parameters:
    ///   - path: 图片路径
    ///   - quality: 质量 0-100
    ///   - resize: 重新设置图片大小
    ///   - outputPath: 输出路径
    /// - Returns: 结果
    @objc
    public func compress(image path: String, quality: Float = 100, resize: CGSize, outputPath: String) -> IMResult {
        let cmds =
            """
            convert -quality \(quality)%% -resize \(resize.width)x\(resize.height) \(path) \(outputPath)
            """
        return cliConvert(cmds:cmds)
    }
    /// 模糊操作，可以抠图
    /// bgColor - 透明背景
    /// toColor - 色差颜色
    @objc
    public func fuzz(bgColor: UIColor, toColor: UIColor, inputPath: String, outputPath: String) -> IMResult {
        let fuzz = IMTool.fuzz(fromColor: bgColor, toColor: toColor)
        
        let cmds =
            """
                magick -debug all -fuzz \(fuzz)%  -transparent #\(bgColor.hexString) \(inputPath) \(outputPath)
            """
        return cliConvert(cmds:cmds)
    }
    
    // MARK: - CLI
    // https://imagemagick.org/script/command-line-processing.php
    
    /// convert 命令
    /// eg: 'convert rose.jpg -resize 50% rose.png'
    @objc
    @discardableResult
    public func cliConvert(cmds: String) -> IMResult {
        return IMConvertCommand(cmds: cmds).execute().transformIMResult()
    }

    /// identify 命令
    @objc
    @discardableResult
    public func cliIdentify(cmds: String) -> IMResult {
        return IMIdentifyCommand(cmds: cmds).execute().transformIMResult()
    }

    /// mogrify 命令
    @objc
    @discardableResult
    public func cliMogrify(cmds: String) -> IMResult {
        return IMMogrifyCommand(cmds: cmds).execute().transformIMResult()
    }

    /// composite 命令
    /// ps: "composite -gravity center smile.gif  rose: rose-over.png"
    @objc
    @discardableResult
    public func cliComposite(cmds: String) -> IMResult {
        return IMCompositeCommand(cmds: cmds).execute().transformIMResult()
    }

    /// compare 命令
    @objc
    public func cliCompare(cmds: String) -> IMResult {
        return IMCompareCommand(cmds: cmds).execute().transformIMResult()
    }

    /// conjure 命令
    @objc
    @discardableResult
    public func cliConjure(cmds: String) -> IMResult {
        return IMConjureCommand(cmds: cmds).execute().transformIMResult()
    }

    /// stream 命令
    @objc
    @discardableResult
    public func cliStream(cmds: String) -> IMResult {
        return IMStreamCommand(cmds: cmds).execute().transformIMResult()
    }

    /// `import` 命令
    @objc
    @discardableResult
    public func cliImport(cmds: String) -> IMResult {
        return IMImportCommand(cmds: cmds).execute().transformIMResult()
    }

    /// display 命令
    @objc
    @discardableResult
    public func cliDisplay(cmds: String) -> IMResult {
        return IMDisplayCommand(cmds: cmds).execute().transformIMResult()
    }

    /// animate 命令
    @objc
    @discardableResult
    public func cliAnimate(cmds: String) -> IMResult {
        return IMAnimateCommand(cmds: cmds).execute().transformIMResult()
    }

    /// montage 命令
    @objc
    @discardableResult
    public func cliMontage(cmds: String) -> IMResult {
        return IMMontageCommand(cmds: cmds).execute().transformIMResult()
    }
}
