//
//  Magick.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/23.
//

import Foundation
@_implementationOnly import Magick

final class IMImageInfo: NSObject {
    var info: UnsafeMutablePointer<ImageInfo>?
    
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
    
    static func nilExc(_ description: String = "") -> IMExceptionInfoError {
        let exc = IMExceptionInfoError(kind: .init(0), errno: 0, reason: "", description: description)
        return exc
    }
    
    static func exceptionInfo(errInfo: UnsafeMutablePointer<ExceptionInfo>?) -> IMExceptionInfoError {
        guard let info = errInfo else {
            return .nilExc("ExceptionInfo is nil")
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
    let output: String?
}


