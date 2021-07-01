//
//  IMImportCommand.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import Magick

class IMImportCommand:IMCommandBase {
    override func command() {
        _ = ImportImageCommand(self.imageInfo.info, Int32(self.args.count), &self.args, &self.meta, self.exc)
    }
}
