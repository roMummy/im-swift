//
//  TestViewController.swift
//  ImageMagickDemo
//
//  Created by FSKJ on 2021/6/26.
//

import IMSDK
import UIKit

class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let inputPath = Bundle.main.path(forResource: "wizard", ofType: "jpg")
        let markPath = Bundle.main.path(forResource: "logo", ofType: "jpg")
        let outputPath = NSTemporaryDirectory() + "out.png"
        if FileManager.default.fileExists(atPath: outputPath) {
            try? FileManager.default.removeItem(atPath: outputPath)
        }
        guard let path = inputPath else {
            return
        }
//        let cmd = """
//                convert \
//                   -size 50x50 xc:none  -font OpenSans-Regular -gravity center -annotate +0+0 "A B C" \(outputPath)
//                """

//        let cmd = """
//                convert \
//                -debug draw \
//                   -size 50x50 xc:none -font OpenSans-Regular -gravity center -annotate +0+0 ABC \(outputPath)
//                """
//        let cmd = """
//                montage -background 'red' -geometry +4+4 \(inputPath!) \(markPath!) \(outputPath)
//                """
//        let cmd = """
//        convert -paint 4 \(inputPath!) \(outputPath)
//        """

//
//        let cmd = """
//                composite  -dissolve 15 -tile \
//                \(markPath!) \(inputPath!) \(outputPath)
//                """

//        let cmds = cmd.components(separatedBy: " ").filter{!$0.isEmpty}

//        print(cmds)
//        let result = IMConvertCommand(cmds: cmd).execute()
//        let result = IMCompositeCommand(cmds: cmd).execute()
//        let result = IMMontageCommand(cmds: cmd).execute()
//        let result = Magick().exeCommand(command: cmds)
//        let result = IMIdentifyCommand(cmds: cmd).execute()
//        let result = IMHelper.shared.cilMontage(cmds: cmd)
//        switch result {
//        case let .success(item):
//            let image = UIImage.init(contentsOfFile: outputPath)
//            print(image)
//            print("success - ", item.meta)
//        case let .failure(error):
//            print("error - ", error.localizedDescription)
//        }

//        let result = IMHelper.shared.addWatermark(mark: markPath!, inputPath: inputPath!, outputPath: outputPath)
//        let result = IMHelper.shared.crop(image: inputPath!, size: CGSize(width: 100, height: 30), point: CGPoint(x: 0, y: 0), outputPath: outputPath)


//
        
//        let cmd1 = ####"""
//                convert -density 90 '#999999' \####(inputPath!) \####(outputPath)
//                """####
//        _ = IMCore.shared.cliConvert(cmds: cmd1)
//
//        let cmd = """
//                identify \(outputPath)
//                """
        
        let cmd = """
                convert -list configure
                """
        let result = IMCore.shared.cliConvert(cmds: cmd)

//        var font: Int8 = 0
//        var number: size_t = 0
//        MagickQueryFonts(&font, &number)
//        print(number)

        print("----")

        if result.status == .success {
            print("success")
        } else {
            print("fail - \(result.errorMsg ?? "")")
        }
    }
}
