if [  $CONFIGURATION == Release ]
then
    echo 'release build'
    #exit 0
else
    echo 'debug build'
    exit 0
fi

# 获取包路径
rootPub=../dist/${PRODUCT_NAME}/iphoneos/

if [  $EFFECTIVE_PLATFORM_NAME == -iphonesimulator ]
then
    echo '模拟器'
    rootPub=../dist/${PRODUCT_NAME}/iphonesimulator/
    rm -rf ${rootPub}
else
    echo '真机'
    rm -rf ${rootPub}
fi

# 将包从默认输出路径复制到dist目录

mkdir -p ${rootPub}

cp -rf ${CODESIGNING_FOLDER_PATH} ${rootPub}
echo "CODESIGNING_FOLDER_PATH"
echo ${CODESIGNING_FOLDER_PATH}

# 合并真机模拟器sdk
DEVICE_DIR=../dist/${PRODUCT_NAME}/iphoneos/${PRODUCT_NAME}.framework
SIMULATOR_DIR=../dist/${PRODUCT_NAME}/iphonesimulator/${PRODUCT_NAME}.framework
# 如果真机包或模拟包不存在，则退出合并
if [ ! -d "${DEVICE_DIR}" ] || [ ! -d "${SIMULATOR_DIR}" ]
then
echo "真机包或模拟包不存在，退出合并" 
exit 0
fi

cp -r ${DEVICE_DIR}  Frameworks/
# ### 清理资源
# rm -rf ../${PRODUCT_NAME}/Frameworks/*
rm -rf ../dist/${PRODUCT_NAME}/


# MergePath=../dist/${PRODUCT_NAME}/merge/
# rm -rf ${MergePath}
# mkdir -p  ${MergePath}

# Merged_DIR=../dist/${PRODUCT_NAME}/merge/${PRODUCT_NAME}.xcframework
# echo "合并开始"
# xcodebuild -create-xcframework -framework "${DEVICE_DIR}" -framework "${SIMULATOR_DIR}" -output "${Merged_DIR}"
# echo "复制完成的xcframework到对应目录"
# cp -r ../dist/${PRODUCT_NAME}/iphoneos/ ${MergePath}
# echo "复制完成"
# mkdir -p "${MergePath}${PRODUCT_NAME}.framework"
# #lipo "${SIMULATOR_DIR}/${PRODUCT_NAME}" -remove arm64 -output "${SIMULATOR_DIR}/${PRODUCT_NAME}"
# # lipo -create "${DEVICE_DIR}/${PRODUCT_NAME}" "${SIMULATOR_DIR}/${PRODUCT_NAME}" -output "${MergePath}${PRODUCT_NAME}.framework/${PRODUCT_NAME}"

# # copy assets Bundle: disable copy bundle
# rm -rf ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle/*.plist
# rm -rf ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle/_CodeSignature
# cp -r  ${DWARF_DSYM_FOLDER_PATH}/${PRODUCT_NAME}.bundle  ${MergePath}

# rm -rf Frameworks/
# mkdir -p Frameworks/
# ### 清理资源
# rm -rf ../${PRODUCT_NAME}/Frameworks/*
# mv ${MergePath}/* Frameworks/
# rm -rf ../dist/${PRODUCT_NAME}/