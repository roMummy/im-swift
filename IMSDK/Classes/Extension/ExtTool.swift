//
//  ExtTool.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import UIKit

extension String {
    func toUnsafePointer() -> UnsafePointer<UInt8>? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        let stream = OutputStream(toBuffer: buffer, capacity: data.count)
        stream.open()
        let value = data.withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
        }
        guard let val = value else {
            return nil
        }
        stream.write(val, maxLength: data.count)
        stream.close()

        return UnsafePointer<UInt8>(buffer)
    }

    func toUnsafeMutablePointer() -> UnsafeMutablePointer<Int8>? {
        return strdup(self)
    }

    /// 文字转图片
    /// - Parameters:
    ///   - textColor: 字体颜色
    ///   - opaque: 不透明
    ///   - bgColor: 背景颜色
    ///   - scale: 缩放 默认不缩放
    ///   - font: 字体
    /// - Returns: 图片
    func toImage(textColor: UIColor = .black, font: UIFont = .systemFont(ofSize: 12), opaque: Bool = true, bgColor: UIColor = .white, scale: CGFloat = 0) -> UIImage? {
        let label = UILabel()
        label.text = self
        label.numberOfLines = 0
        label.backgroundColor = bgColor
        label.textColor = textColor
        label.font = font
        label.sizeToFit()
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, opaque, 0)
        if let currentContext = UIGraphicsGetCurrentContext() {
            label.layer.render(in: currentContext)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}

extension UnsafeMutablePointer where Pointee == Int8 {
    static var empty: UnsafeMutablePointer<Int8> {
        return "".toUnsafeMutablePointer()!
    }
}

extension Result where Success == ImageCommandResult, Failure == IMExceptionInfoError {
    func transformIMResult() -> IMResult {
        let result = IMResult()
        switch self {
        case let .success(r):
            result.status = .success
            result.info = r.info
            result.meta = r.meta
            break
        case let .failure(err):
            result.status = .fail
            result.errorMsg = err.localizedDescription
        }
        return result
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255,
            G: CGFloat((hex >> 08) & 0xFF) / 255,
            B: CGFloat((hex >> 00) & 0xFF) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff))
      }

    var r: CGFloat {
        let ciColor = CIColor(color: self)
        return ciColor.red
    }
    
    var g: CGFloat {
        let ciColor = CIColor(color: self)
        return ciColor.green
    }
    
    var b: CGFloat {
        let ciColor = CIColor(color: self)
        
        return ciColor.blue
    }
    
    var a: CGFloat {
        let ciColor = CIColor(color: self)
        return ciColor.alpha
    }
}
