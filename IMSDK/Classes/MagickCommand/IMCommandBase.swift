//
//  IMCommandBase.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import Magick

class IMCommandBase: IMCommand {
    var params: [String]
    var imageInfo: IMImageInfo
    var meta: UnsafeMutablePointer<Int8>?
    var exc: UnsafeMutablePointer<ExceptionInfo>?
    var args: [UnsafeMutablePointer<Int8>?]
    
    required init(cmds: String) {
        let cmdList = IMTool.split(str: cmds, filters: ["\"", "'","(",")"], whereSeparator: " ")

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
    
    deinit {
        for ptr in self.args {
            free(UnsafeMutablePointer(mutating: ptr))
        }
        DestroyString(meta)
        DestroyExceptionInfo(exc)
    }
}
