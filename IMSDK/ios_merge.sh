#!/bin/bash
# 检查输入的路径是否有效
if [[ ! -f "$1" && ! -d "$1" ]]; then
    echo "无效的路径，请提供正确的.xcworkspace文件路径。"
    exit 1
fi

# 获取工作区文件路径参数
WORKSPACE_PATH="$1"

# 提取文件名（不包含扩展名）作为项目名称
PROJECT_NAME=$(basename "$WORKSPACE_PATH" | sed 's/\.[^.]*$//')

# 设置其他变量
OUTPUT_DIR="output"

# 清理之前的构建
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# 编译 iOS 真机 Release 架构
xcodebuild archive -project "$WORKSPACE_PATH" -scheme "$PROJECT_NAME" -archivePath "$OUTPUT_DIR/iphoneos.xcarchive" -sdk iphoneos -configuration Release SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 编译 iOS 模拟器 arm64 Release 架构
xcodebuild archive -project "$WORKSPACE_PATH" -scheme "$PROJECT_NAME" -archivePath "$OUTPUT_DIR/ios_sim_arm64.xcarchive" -sdk iphonesimulator -arch arm64 -configuration Release SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 编译 iOS 模拟器 x86_64 Release 架构
xcodebuild archive -project "$WORKSPACE_PATH" -scheme "$PROJECT_NAME" -archivePath "$OUTPUT_DIR/ios_sim_x86_64.xcarchive" -sdk iphonesimulator -arch x86_64 -configuration Release SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# 创建 iOS 真机 framework 目录
mkdir -p "$OUTPUT_DIR/iphoneos"
cp -R "$OUTPUT_DIR/iphoneos.xcarchive/Products/Library/Frameworks/$PROJECT_NAME.framework" "$OUTPUT_DIR/iphoneos/"

# 创建 iOS 模拟器 arm64 framework 目录
mkdir -p "$OUTPUT_DIR/ios_sim_arm64"
cp -R "$OUTPUT_DIR/ios_sim_arm64.xcarchive/Products/Library/Frameworks/$PROJECT_NAME.framework" "$OUTPUT_DIR/ios_sim_arm64/"

# 创建 iOS 模拟器 x86_64 framework 目录
mkdir -p "$OUTPUT_DIR/ios_sim_x86_64"
cp -R "$OUTPUT_DIR/ios_sim_x86_64.xcarchive/Products/Library/Frameworks/$PROJECT_NAME.framework" "$OUTPUT_DIR/ios_sim_x86_64/"

# 将arm64进行模拟器arm64架构编译, 解决arm64库冲突问题
rm -rf $OUTPUT_DIR/temp
mkdir $OUTPUT_DIR/temp
cd $OUTPUT_DIR/temp

ar x "../ios_sim_arm64/$PROJECT_NAME.framework/$PROJECT_NAME"

ARM64_TO_SIM_PATH="Path/arm64-to-sim-main/.build/apple/Products/Release/arm64-to-sim"

for file in *.o; do echo processing $file && $ARM64_TO_SIM_PATH $file; done;

ar crv "../ios_sim_arm64/$PROJECT_NAME.framework/$PROJECT_NAME-sim-arm64" *.o

cd ..

# 合并x86_64与arm64
rm -rf merge
mkdir -p merge/arm64_x86_64

lipo -create ios_sim_arm64/$PROJECT_NAME.framework/$PROJECT_NAME-sim-arm64 ios_sim_x86_64/$PROJECT_NAME.framework/$PROJECT_NAME -output merge/arm64_x86_64/$PROJECT_NAME

rm -rf ios_sim_arm64/$PROJECT_NAME.framework/$PROJECT_NAME-sim-arm64

lipo -info merge/arm64_x86_64/$PROJECT_NAME

cp -R merge/arm64_x86_64/$PROJECT_NAME ios_sim_arm64/$PROJECT_NAME.framework/

lipo -info ios_sim_arm64/$PROJECT_NAME.framework/$PROJECT_NAME

rm -rf $PROJECT_NAME.xcframework

# 创建 xcframework
xcodebuild -create-xcframework \
-framework iphoneos/$PROJECT_NAME.framework \
-framework ios_sim_arm64/$PROJECT_NAME.framework \
-output $PROJECT_NAME.xcframework

# rm -rf ios_sim_arm64
# rm -rf ios_sim_arm64.xcarchive

# rm -rf ios_sim_x86_64
# rm -rf ios_sim_x86_64.xcarchive

# rm -rf iphoneos
# rm -rf iphoneos.xcarchive

# rm -rf merge
# rm -rf temp

echo "编译完成. xcframework地址: $OUTPUT_DIR/$PROJECT_NAME.xcframework"



# xcodebuild archive -project "$WORKSPACE_PATH" -scheme "$PROJECT_NAME" -archivePath "$OUTPUT_DIR/ios_sim_x86_64.xcarchive" -sdk iphonesimulator -arch x86_64 -configuration Release SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


# cd output

# xcodebuild -create-xcframework \
# -framework iphoneos/IMSDK.framework \
# -framework ios_sim_arm64/IMSDK.framework \
# -output IMSDK.xcframework