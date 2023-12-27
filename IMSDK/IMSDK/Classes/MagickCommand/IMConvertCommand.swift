//
//  IMConvertCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
@_implementationOnly import Magick

class IMConvertCommand: IMCommandBase {
    override func command() {
        _ = ConvertImageCommand(self.imageInfo.info, Int32(self.args.count), &self.args, &self.meta, self.exc)
    }
}
