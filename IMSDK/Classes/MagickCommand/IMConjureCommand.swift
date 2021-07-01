//
//  IMConjureCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import Magick

class IMConjureCommand:IMCommandBase {
    override func command() {
        _ = ConjureImageCommand(self.imageInfo.info, Int32(self.args.count), &self.args, &self.meta, self.exc)
    }
}
