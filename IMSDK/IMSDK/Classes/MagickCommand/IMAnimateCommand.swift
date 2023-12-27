//
//  IMAnimateCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
@_implementationOnly import Magick

class IMAnimateCommand:IMCommandBase {
    override func command() {
        _ = AnimateImageCommand(self.imageInfo.info, Int32(self.args.count), &self.args, &self.meta, self.exc)
    }
}
