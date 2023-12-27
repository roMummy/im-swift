//
//  IMCompareCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
@_implementationOnly import Magick

import Foundation

class IMCompareCommand:IMCommandBase {
    override func command() {
        _ = CompareImagesCommand(self.imageInfo.info, Int32(self.args.count), &self.args, &self.meta, self.exc)
    }
}
