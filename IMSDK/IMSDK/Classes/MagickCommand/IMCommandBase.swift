//
//  IMCommandBase.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
@_implementationOnly import Magick

/// 进度回调
/// - Parameters:
///   - text: 输出文本
///   - offset: 偏移数据
///   - extent: 总大小
///   - context: 上下文环境
/// - Returns: 获取进度成功 or 失败
func magicProgressMonitor(_ text: UnsafePointer<CChar>?,
                          _ offset: MagickOffsetType,
                          _ extent: MagickSizeType,
                          _ context: UnsafeMutableRawPointer?) -> MagickBooleanType {
    guard let context = context else {
        return MagickFalse
    }
    let command = Unmanaged<IMCommandBase>.fromOpaque(context).takeUnretainedValue()
    let progressValue = Float(offset)/Float(extent)
    
    command.progressBlock?(progressValue)
//    print("[IM] - 进度 \(progressValue)")
    
    return MagickTrue
}

class IMCommandBase: IMCommand {
    var params: [String]
    var imageInfo: IMImageInfo
    var meta: UnsafeMutablePointer<Int8>?
    var exc: UnsafeMutablePointer<ExceptionInfo>?
    var args: [UnsafeMutablePointer<Int8>?]
    var progressBlock:((Float) -> Void)?
    
    required init(cmds: String) {
        let cmdList = IMTool.split(str: cmds, filters: ["\"", "'"], whereSeparator: " ")

        self.params = cmdList
        self.imageInfo = IMImageInfo()
        self.exc = AcquireExceptionInfo()
        self.args = cmdList.map{UnsafeMutablePointer<Int8>(strdup($0))}
        let empty = "".toUnsafeMutablePointer()
        self.meta = AcquireString(empty)
        
        defer {
            free(empty)
        }
    }
    
    func command() {
        fatalError("sub must implement this method!!!")
    }
    
    func progressMonitor() {
        let observer = IMTool.bridge(obj: self)
        progressBlock = IMCore.shared.progressBlock
        SetImageInfoProgressMonitor(self.imageInfo.info, magicProgressMonitor(_:_:_:_:), UnsafeMutableRawPointer(mutating: observer))
    }
    
    deinit {
        for ptr in self.args {
            free(UnsafeMutablePointer(mutating: ptr))
        }
        DestroyString(meta)
        DestroyExceptionInfo(exc)
    }
}
