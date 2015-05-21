A sample Android Studio project integrated with Go's NativeActivity lib.

Used the example: http://godoc.org/golang.org/x/mobile/example/sprite

Go sources are in: app/src/main/go/

Build script: app/src/main/go/make.bash . Edit make.bash to suit your environment.

#### make.bash

```bash
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
```



### Changes to the default Android Studio project:


Create a folder "go" in app/src/main. Put your go code here.

#### app/build.gradle: 

```java
...

// begin
task goBuild(type: Exec, description: 'Compile Go NativeActivity lib') {
    commandLine "./src/main/go/make.bash"
}
tasks.withType(JavaCompile) {
    compileTask -> compileTask.dependsOn goBuild
}
//end
...

```

jniLibs is bundled in the final apk by gradle.

#### AndroidManifest.xml: 

```xml
...	

<activity android:name="android.app.NativeActivity"
    android:label="Sprite"
    android:configChanges="orientation|keyboardHidden">
    <meta-data android:name="android.app.lib_name" android:value="sprite" />
</activity>
...

```

"sprite" is the library name corresponding to libsprite.so .


#### MainActivity.java

```java
...

 Intent intent=new Intent();
 intent.setComponent(new ComponentName("com.adnaan.gomobileandroidgradle", "android.app.NativeActivity"));
 startActivity(intent);
 ...

 ```
 
#### Assets

 Copy your assets in src/main/assets
