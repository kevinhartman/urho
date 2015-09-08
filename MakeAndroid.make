#armeabi-v7a, x86, armeabi
ABI=x86
#x86, arm
PLATFORM=x86
TOOLCHAINS_VER=4.9
ANDROID_API=android-12

ANDK_DIR=C:/Users/Egor/Documents/Android/ndk/android-ndk-r10d
ANDK_GCC=$(ANDK_DIR)/toolchains/x86-$(TOOLCHAINS_VER)/prebuilt/windows-x86_64/bin/i686-linux-android-gcc.exe
ANDK_GPP=$(ANDK_DIR)/toolchains/x86-$(TOOLCHAINS_VER)/prebuilt/windows-x86_64/bin/i686-linux-android-g++.exe
ANDK_STRIP=$(ANDK_DIR)/toolchains/x86-$(TOOLCHAINS_VER)/prebuilt/windows-x86_64/bin/i686-linux-android-strip.exe

OUTPUT_DIR=Bin/Android/$(ABI)
URHO3D_SRC_DIR=Urho3D/Source
URHO3D_ANDROID_DIR=Urho3D/Urho3D_Android

C_FLAGS = -fexceptions -fPIC --sysroot=$(ANDK_DIR)/platforms/$(ANDROID_API)/arch-$(PLATFORM) -funwind-tables -funswitch-loops -finline-limit=300 -fsigned-char -no-canonical-prefixes -fdata-sections -ffunction-sections -Wa,--noexecstack  -fstack-protector -fomit-frame-pointer -fstrict-aliasing -O3 -DNDEBUG -isystem $(ANDK_DIR)/platforms/$(ANDROID_API)/arch-$(PLATFORM)/usr/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/libs/$(ABI)/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/include/backward -I$(URHO3D_ANDROID_DIR)/include -I$(URHO3D_ANDROID_DIR)/include/Urho3D/ThirdParty -I$(URHO3D_ANDROID_DIR)/include/Urho3D/ThirdParty/Bullet -I$(URHO3D_SRC_DIR)/Source/Samples 

C_DEFINES = -DANDROID -DHAVE_STDINT_H -DKNET_UNIX -DURHO3D_ANGELSCRIPT -DURHO3D_FILEWATCHER -DURHO3D_LOGGING -DURHO3D_NAVIGATION -DURHO3D_NETWORK -DURHO3D_OPENGL -DURHO3D_PHYSICS -DURHO3D_PROFILING -DURHO3D_SSE -DURHO3D_STATIC_DEFINE -DURHO3D_URHO2D

CXX_FLAGS = -fexceptions -frtti -std=c++11 -fpermissive -fPIC --sysroot=$(ANDK_DIR)/platforms/$(ANDROID_API)/arch-$(PLATFORM) -funwind-tables -funswitch-loops -finline-limit=300 -fsigned-char -no-canonical-prefixes -fdata-sections -ffunction-sections -Wa,--noexecstack  -Wno-invalid-offsetof -fstack-protector -fomit-frame-pointer -fstrict-aliasing -O3 -DNDEBUG -isystem $(ANDK_DIR)/platforms/$(ANDROID_API)/arch-$(PLATFORM)/usr/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/libs/$(ABI)/include -isystem $(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/include/backward -I$(URHO3D_ANDROID_DIR)/include -I$(URHO3D_ANDROID_DIR)/include/Urho3D/ThirdParty -I$(URHO3D_ANDROID_DIR)/include/Urho3D/ThirdParty/Bullet -I$(URHO3D_SRC_DIR)/Source/Samples

CXX_DEFINES = -DANDROID -DHAVE_STDINT_H -DKNET_UNIX -DURHO3D_ANGELSCRIPT -DURHO3D_FILEWATCHER -DURHO3D_LOGGING -DURHO3D_NAVIGATION -DURHO3D_NETWORK -DURHO3D_OPENGL -DURHO3D_PHYSICS -DURHO3D_PROFILING -DURHO3D_SSE -DURHO3D_STATIC_DEFINE -DURHO3D_URHO2D

ApplicationProxy.o:
	$(ANDK_GPP) $(CXX_DEFINES) $(CXX_FLAGS) -o ApplicationProxy.cpp.o -c bindings/src/ApplicationProxy.cpp
	
Glue.o:
	$(ANDK_GPP) $(CXX_DEFINES) $(CXX_FLAGS) -o glue.cpp.o -c bindings/src/glue.cpp
	
Vector.o:
	$(ANDK_GPP) $(CXX_DEFINES) $(CXX_FLAGS) -o Vector.cpp.o -c bindings/src/Vector.cpp
	
Binding.o:
	$(ANDK_GPP) $(CXX_DEFINES) $(CXX_FLAGS) -o binding.cpp.o -c bindings/generated/binding.cpp
	
Events.o:
	$(ANDK_GPP) $(CXX_DEFINES) $(CXX_FLAGS) -o events.cpp.o -c bindings/generated/events.cpp

SDL.o:
	$(ANDK_GCC) $(C_DEFINES) $(C_FLAGS) -o SDL_android_main.c.o -c $(URHO3D_SRC_DIR)/Source/ThirdParty/SDL/src/main/android/SDL_android_main.c

Urho3D_Android:
	mkdir -p $(URHO3D_ANDROID_DIR) && cd $(URHO3D_SRC_DIR) && cmake -E make_directory ../Urho3D_Android && cmake -E chdir ../Urho3D_Android cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=$(CURDIR)/$(URHO3D_SRC_DIR)/CMake/Toolchains/android.toolchain.cmake .../Urho3D_Android -DANDROID=1 -DANDROID_ABI=$(ABI) $(CURDIR)/$(URHO3D_SRC_DIR)/
	
libUrho3D.a: Urho3D_Android
	cd $(URHO3D_ANDROID_DIR) && make Urho3D

libmono-urho.so: libUrho3D.a ApplicationProxy.o Glue.o Vector.o Binding.o Events.o SDL.o
	mkdir -p $(OUTPUT_DIR) && $(ANDK_GCC)  -fPIC -fexceptions -frtti -fPIC --sysroot=$(ANDK_DIR)/platforms/$(ANDROID_API)/arch-$(PLATFORM) -funwind-tables -funswitch-loops -finline-limit=300 -fsigned-char -no-canonical-prefixes -fdata-sections -ffunction-sections -Wa,--noexecstack  -Wno-invalid-offsetof -fstack-protector -fomit-frame-pointer -fstrict-aliasing -O3 -DNDEBUG  -Wl,--no-undefined -Wl,--gc-sections -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now  -shared -Wl,-soname,libmono-urho.so -o $(OUTPUT_DIR)/libmono-urho.so ApplicationProxy.cpp.o Vector.cpp.o Glue.cpp.o events.cpp.o binding.cpp.o SDL_android_main.c.o $(URHO3D_ANDROID_DIR)/libs/$(ABI)/libUrho3D.a -ldl -llog -landroid -lGLESv1_CM -lGLESv2  "$(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/libs/$(ABI)/libgnustl_static.a" "$(ANDK_DIR)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAINS_VER)/libs/$(ABI)/libsupc++.a" -lm && $(ANDK_STRIP) $(OUTPUT_DIR)/libmono-urho.so && rm *.o
