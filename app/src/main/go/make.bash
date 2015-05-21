#!/usr/bin/env bash
#edit env variables
export GOPATH=$HOME/code/nuts 
export GOROOT=$HOME/go
export PATH=$HOME/android-toolchain/bin
export PATH=$PATH:$GOROOT/bin

mkdir -p src/main/jniLibs/armeabi-v7a

cd src/main/go

#build shared library
CGO_ENABLED=1 GOOS=android GOARCH=arm GOARM=7 CC=arm-linux-androideabi-gcc CCX=arm-linux-androideabi-g++ GOGCCFLAGS=-"fPIC -marm -pthread -fmessage-length=0" go build -v -ldflags="-shared" .
#move shared library to jniLibs
/bin/mv -f go ../jniLibs/armeabi-v7a/libsprite.so