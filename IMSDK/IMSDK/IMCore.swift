//
//  IMCore.swift
//  PCSDK
//
//  Created by FSKJ on 2021/8/18.
//

import Foundation
import UIKit

/// IMSDK 对外暴露类
open class IMCore: NSObject {
    @objc public static let shared = IMCore()
    fileprivate override init() {
        super.init()
    }
    
    /// 处理进度回调 0 - 1.0
   @objc public var progressBlock: ((Float) -> Void)?
    
    /// 格式转换
    /// 如果是gif -> jpg 会生成多个文件outut-0.jpg、output-1.jpg ...
    @objc
    public func conver(inputPath: String, outputPath: String) -> IMResult {
        return IMHelper.shared.conver(inputPath: inputPath, outputPath: outputPath)
    }
    
    /// 多图转换成GIF
    /// - Parameters:
    ///   - inputPaths: 多张输入图片路径
    ///   - delay: 每秒多少帧
    ///   - outputPath: 输出路径
    /// - Returns: 结果
    @objc
    public func convertToGif(inputPaths: [String], delay: Int, outputPath: String) -> IMResult {
        return IMHelper.shared.convertToGif(inputPaths: inputPaths, delay: delay, outputPath: outputPath)
    }
    
    /// 添加图片水印
    @objc
    public func addWatermark(mark imagePath: String, inputPath: String, outputPath: String) -> IMResult {
        return IMHelper.shared.addWatermark(mark: imagePath, inputPath: inputPath, outputPath: outputPath)
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
        return IMHelper.shared.addWatermark(text: text, textColor: textColor, inputPath: inputPath, outputPath: outputPath)
    }
    
    
    /// 图片裁剪
    /// size: 图片大小
    /// point: 开始位置
    @objc
    public func crop(image path: String, size: CGSize, point: CGPoint, outputPath: String) -> IMResult {
        return IMHelper.shared.crop(image: path, size: size, point: point, outputPath: outputPath)
    }
    
    /// 压缩图片
    /// - Parameters:
    ///   - path: 图片路径
    ///   - quality: 质量 0-100 百分比
    ///   - resize: 重新设置图片大小
    ///   - outputPath: 输出路径
    /// - Returns: 结果
    @objc
    public func compress(image path: String, quality: Float = 100, resize: CGSize, outputPath: String) -> IMResult {
        return IMHelper.shared.compress(image: path, quality: quality, resize: resize, outputPath: outputPath)
    }
    /// 模糊操作，可以抠图
    /// bgColor - 透明背景
    /// toColor - 色差颜色
    @objc
    public func fuzz(bgColor: UIColor, toColor: UIColor, inputPath: String, outputPath: String) -> IMResult {
        return IMHelper.shared.fuzz(bgColor: bgColor, toColor: toColor, inputPath: inputPath, outputPath: outputPath)
    }
    
    
    /// 设置dpi，png格式不支持设置dpi
    /// - Parameters:
    ///   - value: dpi值
    ///   - inputPath: 输入路径
    ///   - outputPath: 输出路径
    /// - Returns: 结果
    @objc
    public func dpi(value: Float, image: UIImage, outputPath: String) -> IMResult {
        return IMHelper.shared.dpi(value: CGFloat(value), image: image, outputPath: outputPath)
    }
        
    // MARK: - CLI
    
    // https://imagemagick.org/script/command-line-processing.php
    
    /// convert 命令
    /// eg: 'convert rose.jpg -resize 50% rose.png'
    @objc
    @discardableResult
    public func cliConvert(cmds: String) -> IMResult {
        return IMHelper.shared.cliConvert(cmds: cmds)
    }

    /// identify 命令
    @objc
    @discardableResult
    public func cliIdentify(cmds: String) -> IMResult {
        return IMHelper.shared.cliIdentify(cmds: cmds)
    }

    /// mogrify 命令
    @objc
    @discardableResult
    public func cliMogrify(cmds: String) -> IMResult {
        return IMHelper.shared.cliMogrify(cmds: cmds)
    }

    /// composite 命令
    /// ps: "composite -gravity center smile.gif  rose: rose-over.png"
    @objc
    @discardableResult
    public func cliComposite(cmds: String) -> IMResult {
        return IMHelper.shared.cliComposite(cmds: cmds)
    }

    /// compare 命令
    @objc
    public func cliCompare(cmds: String) -> IMResult {
        return IMHelper.shared.cliCompare(cmds: cmds)
    }

    /// conjure 命令
    @objc
    @discardableResult
    public func cliConjure(cmds: String) -> IMResult {
        return IMHelper.shared.cliConjure(cmds: cmds)
    }

    /// stream 命令
    @objc
    @discardableResult
    public func cliStream(cmds: String) -> IMResult {
        return IMHelper.shared.cliStream(cmds: cmds)
    }

    /// `import` 命令
    @objc
    @discardableResult
    public func cliImport(cmds: String) -> IMResult {
        return IMHelper.shared.cliImport(cmds: cmds)
    }

    /// display 命令
    @objc
    @discardableResult
    public func cliDisplay(cmds: String) -> IMResult {
        return IMHelper.shared.cliDisplay(cmds: cmds)
    }

    /// animate 命令
    @objc
    @discardableResult
    public func cliAnimate(cmds: String) -> IMResult {
        return IMHelper.shared.cliAnimate(cmds: cmds)
    }

    /// montage 命令
    @objc
    @discardableResult
    public func cliMontage(cmds: String) -> IMResult {
        return IMHelper.shared.cliMontage(cmds: cmds)
    }
}
