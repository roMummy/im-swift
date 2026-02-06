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
    # 为不同架构分别输出，避免覆盖
    # 优先使用 CURRENT_ARCH；若为空则从 ARCHS 推断第一个
    ARCH_VALUE="${CURRENT_ARCH}"
    if [ -z "$ARCH_VALUE" ]; then
      ARCH_VALUE="$(echo "$ARCHS" | awk '{print $1}')"
    fi
    # 以实际产物为准探测架构，避免环境变量不准
    BIN_PATH="${BUILT_PRODUCTS_DIR}/${PRODUCT}.framework/${PRODUCT}"
    if [ -f "${BIN_PATH}" ]; then
      ARCH_DETECT="$(lipo -info "${BIN_PATH}" 2>/dev/null || true)"
      case "$ARCH_DETECT" in
        *"architecture: arm64"*)
          ARCH_VALUE="arm64"
          ;;
        *"architecture: x86_64"*)
          ARCH_VALUE="x86_64"
          ;;
      esac
    fi
    case "$ARCH_VALUE" in
      arm64)
        OUT_DIR="${ROOT}/macos-arm64"
        ;;
      x86_64)
        OUT_DIR="${ROOT}/macos-x86_64"
        ;;
      *)
        # 兜底：未知架构时写入通用 macos 目录
        OUT_DIR="${ROOT}/macos"
        ;;
    esac
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
# 3.1 macOS: 自动构建另一架构并合成 fat 框架
# -----------------------------
if [ "$PLATFORM_NAME" = "macosx" ]; then
  # 推断当前架构
  ARCH_VALUE="${CURRENT_ARCH}"
  if [ -z "$ARCH_VALUE" ]; then
    ARCH_VALUE="$(echo "$ARCHS" | awk '{print $1}')"
  fi

  PROJ_PATH="${PROJECT_FILE_PATH}"
  if [ -z "$PROJ_PATH" ]; then
    PROJ_PATH="${SRCROOT}/../IMSDK.xcodeproj"
  fi
  SCHEME="${PRODUCT_NAME}"

  # 另一架构的 dist 输出路径（由本脚本复制）
  ARM_DIST_FW="${ROOT}/macos-arm64/${PRODUCT}.framework"
  X64_DIST_FW="${ROOT}/macos-x86_64/${PRODUCT}.framework"

  # 若当前是 arm64，则构建 x86_64；反之亦然
  if [ "$ARCH_VALUE" = "arm64" ]; then
    echo "Build missing macOS x86_64 slice..."
    /usr/bin/arch -x86_64 xcodebuild -project "${PROJ_PATH}" -scheme "${SCHEME}" -configuration "${CONFIGURATION}" -sdk macosx ARCHS=x86_64 ONLY_ACTIVE_ARCH=YES build || true
  elif [ "$ARCH_VALUE" = "x86_64" ]; then
    echo "Build missing macOS arm64 slice..."
    xcodebuild -project "${PROJ_PATH}" -scheme "${SCHEME}" -configuration "${CONFIGURATION}" -sdk macosx ARCHS=arm64 ONLY_ACTIVE_ARCH=YES build || true
  fi

  # 尝试定位两种架构框架（从 dist 路径）
  if [ -d "${ARM_DIST_FW}" ] && [ -d "${X64_DIST_FW}" ]; then
    echo "Create macOS universal (fat) framework..."
    FAT_DIR="${ROOT}/macos"
    rm -rf "${FAT_DIR}"
    mkdir -p "${FAT_DIR}"

    # 基于 arm64 框架复制结构
    cp -R "${ARM_DIST_FW}" "${FAT_DIR}"
    FAT_FW="${FAT_DIR}/${PRODUCT}.framework"
    FAT_BIN="${FAT_FW}/${PRODUCT}"

    # 先删除复制的二进制，再以两架构合成
    rm -f "${FAT_BIN}"
    lipo -create "${ARM_DIST_FW}/${PRODUCT}" "${X64_DIST_FW}/${PRODUCT}" -output "${FAT_BIN}"
    echo "macOS universal framework ready: ${FAT_FW}"
  else
    echo "Not both macOS slices present; skip fat merge"
  fi
fi

# -----------------------------
# 4. 准备合并 XCFramework
# -----------------------------
IOS_FW="${ROOT}/iphoneos/${PRODUCT}.framework"
SIM_FW="${ROOT}/iphonesimulator/${PRODUCT}.framework"
MAC_UNI="${ROOT}/macos/${PRODUCT}.framework"
MAC_ARM="${ROOT}/macos-arm64/${PRODUCT}.framework"
MAC_X64="${ROOT}/macos-x86_64/${PRODUCT}.framework"

# 等 iOS device + simulator
if [ ! -d "${IOS_FW}" ] || [ ! -d "${SIM_FW}" ]; then
  echo "Waiting for iOS device & simulator"
  exit 0
fi

# 等 macOS：必须存在通用 macos 或同时存在 macos-arm64 与 macos-x86_64
if [ ! -d "${MAC_UNI}" ] && { [ ! -d "${MAC_ARM}" ] || [ ! -d "${MAC_X64}" ]; }; then
  echo "Waiting for macOS arm64 & x86_64"
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

# macOS：优先加入通用 macos 目录；否则分别加入 arm64 / x86_64（两者都加入）
if [ -d "${MAC_UNI}" ]; then
  echo "Including macOS (universal) framework"
  XC_ARGS+=( -framework "${MAC_UNI}" )
else
  echo "Including macOS arm64 + x86_64 frameworks"
  XC_ARGS+=( -framework "${MAC_ARM}" )
  XC_ARGS+=( -framework "${MAC_X64}" )
fi

xcodebuild "${XC_ARGS[@]}" -output "${XC_OUT}"

# -----------------------------
# 5. 自检（非常重要）
# -----------------------------
echo "===== XCFramework Info ====="
plutil -p "${XC_OUT}/Info.plist"

# 验证 macOS 切片（兼容不同命名）
if [ -d "${XC_OUT}/macos-arm64_x86_64" ]; then
  echo "===== macOS (arm64_x86_64) Mach-O ====="
  file "${XC_OUT}/macos-arm64_x86_64/${PRODUCT}.framework/${PRODUCT}"
fi
if [ -d "${XC_OUT}/macos-arm64" ]; then
  echo "===== macOS (arm64) Mach-O ====="
  file "${XC_OUT}/macos-arm64/${PRODUCT}.framework/${PRODUCT}"
fi
if [ -d "${XC_OUT}/macos-x86_64" ]; then
  echo "===== macOS (x86_64) Mach-O ====="
  file "${XC_OUT}/macos-x86_64/${PRODUCT}.framework/${PRODUCT}"
fi

echo "===== Packaging Done ====="
