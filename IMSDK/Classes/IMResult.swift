//
//  IMResult.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/28.
//

import Foundation
import Magick

public class IMResult: NSObject {
    @objc
    public enum Status: Int {
        case fail
        case success
    }

    @objc
    public var status: Status = .fail
    @objc
    public var info: IMImageInfo?
    @objc
    public var meta: String?
    @objc
    public var errorMsg: String?
}
