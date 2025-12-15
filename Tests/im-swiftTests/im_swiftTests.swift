import Testing
import UIKit
import IMSDK


@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
}

@Test func sharedIsSingleton() async throws {
    let a = IMCore.shared
    let b = IMCore.shared
    #expect(a === b)
}

@Test func convertImage() throws {
    let tempDir = NSTemporaryDirectory() + "im_swift_tests/"
    try? FileManager.default.createDirectory(
        atPath: tempDir,
        withIntermediateDirectories: true
    )

    let input = tempDir + "input.jpg"
    let output = tempDir + "output.png"

    // 创建测试图片
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
    let image = renderer.image { ctx in
        UIColor.blue.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    try image.pngData()?.write(to: URL(fileURLWithPath: input))

    let result = IMCore.shared.conver(
        inputPath: input,
        outputPath: output
    )

    #expect(Bool(result.status == .success))
    #expect(FileManager.default.fileExists(atPath: output))
    print(output)
}

@Test func cliConvertWorks() throws {
    let bundle = Bundle.module
    guard let fileURL = bundle.url(forResource: "111", withExtension: "jpg") else {
        #expect(Bool(false), "Missing test resource")
        return
    }
    
    let tempDir = NSTemporaryDirectory() + "im_swift_tests/"
    
    let input = fileURL.path
    let output = tempDir + "cli_output.png"

    let result = IMCore.shared.cliConvert(
        cmds: "convert \(input) \(output)"
    )

    #expect(Bool(result.status == .success))
    
    print(output)
}
