#!/bin/sh

ROOT_DIR=`pwd`/src/boringssl
DIST_DIR=$ROOT_DIR/dist
BUILD_DIR=$ROOT_DIR/build

ABIS="armeabi-v7a arm64-v8a x86 x86_64"

NDK="$ANDROID_HOME/ndk-bundle"
export ANDROID_NDK=$NDK
export NINJA_PATH=/usr/bin/ninja

function build_one {

  mkdir -p $BUILD_DIR/$CPU
  cd $BUILD_DIR/$CPU
  echo "Configuring..."
  cmake -DANDROID_NATIVE_API_LEVEL=${API} -DANDROID_ABI=${CPU} -DCMAKE_BUILD_TYPE=Release -DANDROID_NDK=${NDK} -DCMAKE_TOOLCHAIN_FILE=$NDK/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=16 -GNinja -DCMAKE_MAKE_PROGRAM=${NINJA_PATH} $ROOT_DIR	
  echo "Building..."
  cmake --build .
  
  mkdir -p $DIST_DIR/$CPU
	
  mv crypto/libcrypto.a $DIST_DIR/$CPU
  mv decrepit/libdecrepit.a $DIST_DIR/$CPU
  
}

API=16

CPU=armeabi-v7a
build_one

CPU=x86
build_one

API=21
CPU=arm64-v8a
build_one

CPU=x86_64
build_one
