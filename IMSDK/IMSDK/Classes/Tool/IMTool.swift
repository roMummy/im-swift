//
//  IMTool.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/29.
//

import Foundation
import UIKit.UIColor

struct IMTool {
    
    /// 切割字符串
    /// - Parameters:
    ///   - str: 文本
    ///   - filters: 过滤文本，这些会成对出现
    ///   - isSeparator: 切割字符
    /// - Returns: 切割之后的字符数组
    static func split(str: String, filters: [String] = [], whereSeparator isSeparator: Character) -> [String] {
        var map: [String : Int] = [:]
        let result = str.split { (char) -> Bool in
            // 记录过滤字符串出现次数
            if filters.contains("\(char)") {
                let value = map["\(char)"] ?? 0
                map["\(char)"] = value + 1
            }
            // 如果是奇数就不切割
            if map.values.filter({$0 % 2 != 0}).count > 0 {
                return false
            }
            
            if char == isSeparator {
                return true
            }
            return false
        }
        
        return result.map{"\($0)"}
    }
    /// fuzz 算法
    static func fuzz(fromColor: UIColor, toColor: UIColor) -> CGFloat {
        /*"%[fx:(100)*sqrt( ( (u.r-v.r)^2 +
                                (u.g-v.g)^2 +
                                (u.b-v.b)^2 )*u.a*v.a/3   + (u.a-v.a)^2  )  ]%%" */
        
        let dr = fromColor.r - toColor.r
        let dg = fromColor.g - toColor.g
        let db = fromColor.b - toColor.b
        let da = fromColor.a - toColor.a
        
        let t = sqrt((dr*dr + dg*dg + db*db)/3 + da*da)
        
        return t * 100
    }
}
// MARK: - bridge 桥接
extension IMTool {
   static func bridge<T : AnyObject>(obj : T) -> UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    }

    static func bridge<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }

    static func bridgeRetained<T : AnyObject>(obj : T) -> UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
    }

    static func bridgeTransfer<T : AnyObject>(ptr : UnsafeRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
    }
}
