//
//  Magick.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/23.
//

import Foundation
import Magick

public final class IMImageInfo: NSObject {
    public var info: UnsafeMutablePointer<ImageInfo>?
    
    override init() {
        let ptr = AcquireImageInfo()
        self.info = ptr
        super.init()
    }
    
    deinit {
        if let info = info {
            DestroyImageInfo(info)
            self.info = nil
        }
    }
}

struct IMExceptionInfoError: Error {
    var kind: ExceptionType
    var errno: Int
    var reason: String
    var description: String
    
    var localizedDescription: String {
        return "\(kind) - \(errno): \(reason) - \(description)";
    }
    
    static func nilExc() -> IMExceptionInfoError {
        let exc = IMExceptionInfoError(kind: .init(0), errno: 0, reason: "", description: "")
        return exc
    }
    
    static func exceptionInfo(errInfo: UnsafeMutablePointer<ExceptionInfo>?) -> IMExceptionInfoError {
        guard let info = errInfo else {
            return .nilExc()
        }
        let exc = IMExceptionInfoError(kind: info.pointee.severity,
                                       errno: Int(info.pointee.error_number),
                                       reason: String(cString: info.pointee.reason ?? .empty),
                                       description: String(cString: info.pointee.description ?? .empty))
        return exc
    }
}

struct ImageCommandResult {
    let info: IMImageInfo
    let meta: String
}

//class Magick {
//    typealias IMResult = Result<ImageCommandResult, IMExceptionInfoError>
//
//    func exeCommand(command: [String]) -> IMResult {
//        guard let firstCmd = command.first else {
//            return .failure(.nilExc())
//        }
//        let cmd = (firstCmd as NSString).utf8String
//        MagickCoreGenesis(cmd, MagickFalse)
//        let result = convertImageCommand(args: command)
//        MagickCoreTerminus()
//        
//        return result
//    }
//    
//    func convertImageCommand(args: [String]) -> IMResult {
//        let size = args.count
//        
//        let imageInfo = IMImageInfo()
//        let exc = AcquireExceptionInfo()
//        var cargs = args.map{UnsafeMutablePointer<Int8>(strdup($0))}
//        let empty = "".toUnsafeMutablePointer()
//        var metaStr = AcquireString(empty)
//        
//        defer {
//            for ptr in cargs {
//                free(UnsafeMutablePointer(mutating: ptr))
//            }
//            free(empty)
//            DestroyString(metaStr)
//            DestroyExceptionInfo(exc)
//        }
//        
//        _ = ConvertImageCommand(imageInfo.info, Int32(size), &cargs, &metaStr, exc)
//        
//        if exc?.pointee.severity != UndefinedException {
//            return .failure(IMExceptionInfoError.exceptionInfo(errInfo: exc))
//        }
//        
//        let result = ImageCommandResult(info: imageInfo, meta: String(cString: metaStr!))
//        
//        return .success(result)
//    }
//    
//}


