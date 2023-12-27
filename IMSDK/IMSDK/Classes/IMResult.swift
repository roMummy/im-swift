//
//  IMResult.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
@_implementationOnly import Magick

public class IMResult: NSObject {
    @objc
    public enum Status: Int {
        case fail
        case success
    }
    /// 状态
    @objc
    public var status: Status = .fail    
//    public var info: IMImageInfo?
    /// 元数据
    @objc
    public var meta: String?
    /// 错误信息
    @objc
    public var errorMsg: String?
    
    /// 输出本地路径
    @objc
    public var output: String?
}
