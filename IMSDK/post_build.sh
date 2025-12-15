# if [  $CONFIGURATION == Release ]
# then
#     echo 'release build'
#     #exit 0
# else
#     echo 'debug build'
#     exit 0
# fi

# # 获取包路径
# rootPub=../dist/${PRODUCT_NAME}/iphoneos/

# if [ "$PLATFORM_NAME" = "iphonesimulator" ]
# then
#     echo '模拟器'
#     rootPub=../dist/${PRODUCT_NAME}/iphonesimulator/
#     rm -rf ${rootPub}
# elif [ "$PLATFORM_NAME" = "macosx" ]
# then
#     echo 'macOS (arm64)'
#     rootPub=../dist/${PRODUCT_NAME}/macos/
#     rm -rf ${rootPub}
# else
#     echo '真机'
#     rm -rf ${rootPub}
# fi

# # 将包从默认输出路径复制到dist目录

# mkdir -p ${rootPub}

# SOURCE_FRAMEWORK="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework"
# cp -rf ${SOURCE_FRAMEWORK} ${rootPub}
# echo "SOURCE_FRAMEWORK"
# echo ${SOURCE_FRAMEWORK}

# # 合并真机模拟器sdk
# DEVICE_DIR=../dist/${PRODUCT_NAME}/iphoneos/${PRODUCT_NAME}.framework
# SIMULATOR_DIR=../dist/${PRODUCT_NAME}/iphonesimulator/${PRODUCT_NAME}.framework
# MACOS_DIR=../dist/${PRODUCT_NAME}/macos/${PRODUCT_NAME}.framework
# # 如果真机包或模拟包不存在，则退出合并（在模拟器或maccatalyst阶段会早退，等真机阶段再合并）
# if [ ! -d "${DEVICE_DIR}" ] || [ ! -d "${SIMULATOR_DIR}" ]
# then
# echo "真机包或模拟包不存在，退出合并" 
# exit 0
# fi

# # cp -r ${DEVICE_DIR}  Frameworks/
# # # ### 清理资源
# # # rm -rf ../${PRODUCT_NAME}/Frameworks/*
# # rm -rf ../dist/${PRODUCT_NAME}/


# MergePath=../dist/${PRODUCT_NAME}/merge/
# rm -rf ${MergePath}
# mkdir -p  ${MergePath}

# Merged_DIR=../dist/${PRODUCT_NAME}/merge/${PRODUCT_NAME}.xcframework
# echo "合并开始"

# # 组装可选的 Mac Catalyst 架构
# XC_ARGS=( -create-xcframework -framework "${DEVICE_DIR}" -framework "${SIMULATOR_DIR}" )
# if [ -d "${MACOS_DIR}" ]; then
#   echo "检测到 macOS 框架，加入 xcframework 合并"
#   XC_ARGS+=( -framework "${MACOS_DIR}" )
# fi

# xcodebuild "${XC_ARGS[@]}" -output "${Merged_DIR}"

# echo "复制完成的框架到对应目录"
# cp -r ../dist/${PRODUCT_NAME}/iphoneos/ ${MergePath}
# if [ -d "${SIMULATOR_DIR}" ]; then
#   cp -r ../dist/${PRODUCT_NAME}/iphonesimulator/ ${MergePath}
# fi
# if [ -d "${MACOS_DIR}" ]; then
#   cp -r ../dist/${PRODUCT_NAME}/macos/ ${MergePath}
# fi
# echo "复制完成"

# # copy assets Bundle: disable copy bundle
# rm -rf ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle/*.plist
# rm -rf ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle/_CodeSignature
# cp -r  ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle  ${MergePath}

# rm -rf Frameworks/
# mkdir -p Frameworks/
# # ### 清理资源
# # rm -rf ../${PRODUCT_NAME}/Frameworks/*
# # mv ${MergePath}/* Frameworks/
# # rm -rf ../dist/${PRODUCT_NAME}/

#!/bin/sh
set -e

echo "===== IMSDK Packaging Script ====="

# 仅 Release 执行
if [ "$CONFIGURATION" != "Release" ]; then
  echo "Debug build, skip"
  exit 0
fi

PRODUCT="${PRODUCT_NAME}"
ROOT="${SRCROOT}/../dist/${PRODUCT}"

# -----------------------------
# 1. 判断平台
# -----------------------------
case "$PLATFORM_NAME" in
  iphoneos)
    echo "iOS Device"
    OUT_DIR="${ROOT}/iphoneos"
    ;;
  iphonesimulator)
    echo "iOS Simulator"
    OUT_DIR="${ROOT}/iphonesimulator"
    ;;
  macosx)
    echo "macOS"
    OUT_DIR="${ROOT}/macos"
    ;;
  *)
    echo "Unsupported platform: $PLATFORM_NAME"
    exit 0
    ;;
esac

# -----------------------------
# 2. 在 iphoneos 阶段清理旧产物
# -----------------------------
if [ "$PLATFORM_NAME" = "iphoneos" ]; then
  echo "Cleaning dist directory"
  # rm -rf "${ROOT}"
fi

mkdir -p "${OUT_DIR}"

# -----------------------------
# 3. 拷贝 framework
# -----------------------------
SRC_FW="${BUILT_PRODUCTS_DIR}/${PRODUCT}.framework"

if [ ! -d "${SRC_FW}" ]; then
  echo "Framework not found: ${SRC_FW}"
  exit 1
fi

rm -rf "${OUT_DIR}/${PRODUCT}.framework"
cp -R "${SRC_FW}" "${OUT_DIR}"

echo "Copied: ${OUT_DIR}/${PRODUCT}.framework"

# -----------------------------
# 4. 准备合并 XCFramework
# -----------------------------
IOS_FW="${ROOT}/iphoneos/${PRODUCT}.framework"
SIM_FW="${ROOT}/iphonesimulator/${PRODUCT}.framework"
MAC_FW="${ROOT}/macos/${PRODUCT}.framework"

# 等 iOS device + simulator
if [ ! -d "${IOS_FW}" ] || [ ! -d "${SIM_FW}" ]; then
  echo "Waiting for iOS device & simulator"
  exit 0
fi

MERGE_DIR="${ROOT}/merge"
XC_OUT="${MERGE_DIR}/${PRODUCT}.xcframework"

rm -rf "${MERGE_DIR}"
mkdir -p "${MERGE_DIR}"

echo "Creating XCFramework..."

XC_ARGS=(
  -create-xcframework
  -framework "${IOS_FW}"
  -framework "${SIM_FW}"
)

# macOS 是可选的
if [ -d "${MAC_FW}" ]; then
  echo "Including macOS framework"
  XC_ARGS+=( -framework "${MAC_FW}" )
fi

xcodebuild "${XC_ARGS[@]}" -output "${XC_OUT}"

# -----------------------------
# 5. 自检（非常重要）
# -----------------------------
echo "===== XCFramework Info ====="
plutil -p "${XC_OUT}/Info.plist"

if [ -d "${XC_OUT}/macos-arm64_x86_64" ]; then
  echo "===== macOS Mach-O ====="
  file "${XC_OUT}/macos-arm64_x86_64/${PRODUCT}.framework/${PRODUCT}"
fi

echo "===== Packaging Done ====="

