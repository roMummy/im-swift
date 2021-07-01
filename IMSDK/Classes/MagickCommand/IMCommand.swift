//
//  IMCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import Magick

protocol IMCommand {
    typealias IMResult = Result<ImageCommandResult, IMExceptionInfoError>
    
    var imageInfo: IMImageInfo {get}
    var meta: UnsafeMutablePointer<Int8>? {get}
    var exc: UnsafeMutablePointer<ExceptionInfo>? {get}
    var args: [UnsafeMutablePointer<Int8>?] {get}
    var params: [String] {get}
    
    init(cmds: String)
    
    func execute() -> IMResult
    func command()
}
extension IMCommand {
    func execute() -> IMResult {
        guard let firstCmd = args.first else {
            return .failure(.nilExc())
        }
        MagickCoreGenesis(firstCmd, MagickFalse)
        let result = executeImpl()
        MagickCoreTerminus()
        return result
    }
    fileprivate func executeImpl() -> IMResult {
        print("[IM] cmds: \(params)")
        
        command()

        if exc?.pointee.severity.rawValue ?? 0 > PolicyWarning.rawValue {
            return .failure(IMExceptionInfoError.exceptionInfo(errInfo: exc))
        }
        if exc?.pointee.severity != UndefinedException {
            let warning = IMExceptionInfoError.exceptionInfo(errInfo: exc)
            
            print("[IM WARNING] - " + warning.localizedDescription)
        }

        let result = ImageCommandResult(info: imageInfo, meta: String(cString: meta ?? .empty))

        return .success(result)
    }
}
