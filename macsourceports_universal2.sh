# game/app specific values
export APP_VERSION="1.0"
export ICONSDIR="res"
export ICONSFILENAME="mv"
export PRODUCT_NAME="jk2mvmp"
export EXECUTABLE_NAME="jk2mvmp"
export PKGINFO="APPLEJ2MV"
export COPYRIGHT_TEXT="Jedi Knight Copyright © 2002 Lucasarts. All rights reserved."

#constants
source ../MSPScripts/constants.sh

#fix resolution on cocoa window
export HIGH_RESOLUTION_CAPABLE="true"

rm -rf ${BUILT_PRODUCTS_DIR}

#cmake -G "Unix Makefiles" -DUseInternalLibs=ON -DBuildPortableVersion=OFF ..

#create makefiles with cmake, perform builds with make
rm -rf ${X86_64_BUILD_FOLDER}
mkdir ${X86_64_BUILD_FOLDER}
cd ${X86_64_BUILD_FOLDER}
/usr/local/bin/cmake -DUseInternalLibs=ON -DBuildPortableVersion=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 ..
make -j$NCPU
cd ..

rm -rf ${ARM64_BUILD_FOLDER}
mkdir ${ARM64_BUILD_FOLDER}
cd ${ARM64_BUILD_FOLDER}
cmake -DUseInternalLibs=ON -DBuildPortableVersion=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.12 ..
make -j$NCPU
cd ..

cp ${X86_64_BUILD_FOLDER}/out/Release/jk2mvmenu_x86_64.dylib ${X86_64_BUILD_FOLDER}/out/Release/jk2mvmp.app/Contents/MacOS
mv ${X86_64_BUILD_FOLDER}/out/Release/jk2mvmp.app ${X86_64_BUILD_FOLDER}

cp ${ARM64_BUILD_FOLDER}/out/Release/jk2mvmenu_arm64.dylib ${ARM64_BUILD_FOLDER}/out/Release/jk2mvmp.app/Contents/MacOS
mv ${ARM64_BUILD_FOLDER}/out/Release/jk2mvmp.app ${ARM64_BUILD_FOLDER}

"../MSPScripts/build_app_bundle.sh"

mkdir "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/base"
echo cp -a "${X86_64_BUILD_FOLDER}/out/Release/base/." "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/base"
cp -a "${X86_64_BUILD_FOLDER}/out/Release/base/." "${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}/base"

cp ${X86_64_BUILD_FOLDER}/out/Release/jk2mvmenu_x86_64.dylib ${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}
cp ${ARM64_BUILD_FOLDER}/out/Release/jk2mvmenu_arm64.dylib ${BUILT_PRODUCTS_DIR}/${EXECUTABLE_FOLDER_PATH}

export ENTITLEMENTS_FILE="build/jk2mv.entitlements"

# #sign and notarize
"../MSPScripts/sign_and_notarize.sh" "$1" entitlements
