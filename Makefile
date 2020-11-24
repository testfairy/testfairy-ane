VERSION=1.26.8
CONFIGURATION=Release

all: build/AirTestFairy.ane

# Check https://helpx.adobe.com/ca/air/kb/archived-air-sdk-version.html for latest versions

airsdk/bin/adt:
	rm -rf airsdk
	mkdir airsdk
	wget -P airsdk https://airdownload.adobe.com/air/mac/download/31.0/AIRSDK_Compiler.dmg
	hdiutil attach airsdk/AIRSDK_Compiler.dmg
	cp -R /Volumes/AIR\ SDK/* airsdk/.

ios/AirTestFairy/AirTestFairy/libTestFairy.a:
	curl -L -s -o ./ios/AirTestFairy/AirTestFairy/sdk.zip "http://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}.zip"
	unzip -q -o -d ./ios/AirTestFairy/AirTestFairy ./ios/AirTestFairy/AirTestFairy/sdk.zip libTestFairy.a TestFairy.h
	-rm -f ./ios/AirTestFairy/AirTestFairy/sdk.zip
	
build/ios/libAirTestFairy.a: ios/AirTestFairy/AirTestFairy/libTestFairy.a
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphoneos
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphonesimulator
	mkdir -p ios/build/$(CONFIGURATION)-universal
	lipo -create ios/AirTestFairy/build/$(CONFIGURATION)-iphoneos/libAirTestFairy.a \
		ios/AirTestFairy/build/$(CONFIGURATION)-iphonesimulator/libAirTestFairy.a \
		-output ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a
	mkdir -p build/ios
	cp -f ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a build/ios/libAirTestFairy.a

build/android/libAirTestFairy.jar: 
	ant clean -file android/build.xml
	ant jar -file android/build.xml
	mkdir -p build/android
	cp -f android/bin/libAirTestFairy.jar build/android/libAirTestFairy.jar
	cp -f android/libs/testfairy-sdk.jar build/android/testfairy-sdk.jar

build/AirTestFairy.swc: build/ios/libAirTestFairy.a build/android/libAirTestFairy.jar
	airsdk/bin/compc -source-path actionscript/src \
		-output build/AirTestFairy.swc \
		-swf-version=26 \
		-external-library-path+=airsdk/frameworks/libs/air/airglobal.swc \
		-include-classes com.testfairy.AirTestFairy

build/AirTestFairy.ane: airsdk/bin/adt build/AirTestFairy.swc
	mkdir -p build/ios
	mkdir -p build/android
	mkdir -p build/default
	unzip -o -d build build/AirTestFairy.swc
	cp -f build/library.swf build/ios/library.swf
	cp -f build/library.swf build/android/library.swf
	cp -f build/library.swf build/default/library.swf
	cp -f actionscript/extension.xml build/extension.xml
	cp -f actionscript/platform-ios.xml build/platform-ios.xml
	cp -f actionscript/platform-android.xml build/platform-android.xml
	airsdk/bin/adt -package -target ane build/AirTestFairy.ane build/extension.xml \
		-swc build/AirTestFairy.swc \
		-platform iPhone-ARM -platformoptions build/platform-ios.xml -C build/ios . \
		-platform Android-ARM -platformoptions build/platform-android.xml -C build/android . \
		-platform Android-x86 -platformoptions build/platform-android.xml -C build/android . \
		-platform default -C build/default .

clean:
	-rm -rf build 
	-rm ios/AirTestFairy/AirTestFairy/TestFairy.h
	-rm ios/AirTestFairy/AirTestFairy/libTestFairy.a
	-rm -rf airsdk
