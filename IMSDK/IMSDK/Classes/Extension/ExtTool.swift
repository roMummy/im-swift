//
//  ExtTool.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
#if canImport(UIKit)
import UIKit
public typealias IMColor = UIColor
public typealias IMImage = UIImage
public typealias IMFont = UIFont
public typealias IMLabel = UILabel
#elseif canImport(AppKit)
import AppKit
public typealias IMColor = NSColor
public typealias IMImage = NSImage
public typealias IMFont = NSFont
public typealias IMLabel = NSTextField
#endif

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
    func toImage(textColor: IMColor = .black, font: IMFont = .systemFont(ofSize: 12), opaque: Bool = true, bgColor: IMColor = .white, scale: CGFloat = 0) -> IMImage? {
#if canImport(UIKit)
        let label = IMLabel()
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
#elseif canImport(AppKit)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor
        ]
        let attrString = NSAttributedString(string: self, attributes: attributes)
        let size = attrString.size()
        let image = IMImage(size: size)
        image.lockFocus()
        bgColor.setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()
        attrString.draw(at: NSPoint(x: 0, y: 0))
        image.unlockFocus()
        return image
#else
        return nil
#endif
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
//            result.info = r.info
            result.meta = r.meta
            result.output = r.output
            break
        case let .failure(err):
            result.status = .fail
            result.errorMsg = err.localizedDescription
        }
        return result
    }
}

extension IMColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255,
            G: CGFloat((hex >> 08) & 0xFF) / 255,
            B: CGFloat((hex >> 00) & 0xFF) / 255
        )
        #if canImport(UIKit)
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        #elseif canImport(AppKit)
        self.init(calibratedRed: components.R, green: components.G, blue: components.B, alpha: 1)
        #endif
    }
    
    var hexString: String {
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rr = Int(r * 0xff)
        let gg = Int(g * 0xff)
        let bb = Int(b * 0xff)
        #elseif canImport(AppKit)
        let rgbColor = self.usingColorSpace(.deviceRGB) ?? self
        let rr = Int((rgbColor.redComponent) * 0xff)
        let gg = Int((rgbColor.greenComponent) * 0xff)
        let bb = Int((rgbColor.blueComponent) * 0xff)
        #endif
        return String(format: "%02X%02X%02X", rr, gg, bb)
      }

    var r: CGFloat {
        #if canImport(UIKit)
        let ciColor = CIColor(color: self)
        return ciColor.red
        #elseif canImport(AppKit)
        let rgb = self.usingColorSpace(.deviceRGB) ?? self
        return rgb.redComponent
        #endif
    }
    
    var g: CGFloat {
        #if canImport(UIKit)
        let ciColor = CIColor(color: self)
        return ciColor.green
        #elseif canImport(AppKit)
        let rgb = self.usingColorSpace(.deviceRGB) ?? self
        return rgb.greenComponent
        #endif
    }
    
    var b: CGFloat {
        #if canImport(UIKit)
        let ciColor = CIColor(color: self)
        return ciColor.blue
        #elseif canImport(AppKit)
        let rgb = self.usingColorSpace(.deviceRGB) ?? self
        return rgb.blueComponent
        #endif
    }
    
    var a: CGFloat {
        #if canImport(UIKit)
        let ciColor = CIColor(color: self)
        return ciColor.alpha
        #elseif canImport(AppKit)
        return self.usingColorSpace(.deviceRGB)?.alphaComponent ?? 1
        #endif
    }
}
