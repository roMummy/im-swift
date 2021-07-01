//
//  IMTool.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/29.
//

import Foundation


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
}
