VERSION=1.5.0
CONFIGURATION=Release

all: build/AirTestFairy.ane

airsdk/bin/adt:
	rm -rf airsdk
	mkdir airsdk
	wget -P airsdk http://airdownload.adobe.com/air/mac/download/17.0/AIRSDK_Compiler.tbz2
	tar xf airsdk/AIRSDK_Compiler.tbz2 -C airsdk
	rm airsdk/AIRSDK_Compiler.tbz2

ios/AirTestFairy/AirTestFairy/libTestFairy.a:
	curl -L -s -o ./ios/AirTestFairy/AirTestFairy/sdk.zip "http://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}.zip"
	unzip -q -o -d ./ios/AirTestFairy/AirTestFairy ./ios/AirTestFairy/AirTestFairy/sdk.zip libTestFairy.a TestFairy.h
	-rm -f ./ios/AirTestFairy/AirTestFairy/sdk.zip
	
build/ios/libAirTestFairy.a: ios/AirTestFairy/AirTestFairy/libTestFairy.a
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphoneos
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphonesimulator
	mkdir -p ios/build/$(CONFIGURATION)-universal
	lipo -create ios/AirTestFairy/build/$(CONFIGURATION)-iphoneos/libAirTestFairy.a ios/AirTestFairy/build/$(CONFIGURATION)-iphonesimulator/libAirTestFairy.a -output ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a
	mkdir -p build/ios
	cp -f ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a build/ios/libAirTestFairy.a

build/android/libAirTestFairy.jar: 
	ant jar -file android/build.xml
	mkdir -p build/android
	cp -f android/bin/libAirTestFairy.jar build/android/libAirTestFairy.jar

build/AirTestFairy.swc: build/ios/libAirTestFairy.a build/android/libAirTestFairy.jar
	airsdk/bin/compc -source-path flex/AirTestFairy/src -output build/AirTestFairy.swc -swf-version=14 -external-library-path+=airsdk/frameworks/libs/air/airglobal.swc -include-classes com.testfairy.AirTestFairy

build/AirTestFairy.ane: airsdk/bin/adt build/AirTestFairy.swc
	mkdir -p build/ios
	mkdir -p build/android
	mkdir -p build/default
	unzip -o -d build build/AirTestFairy.swc library.swf
	cp -f build/library.swf build/ios/library.swf
	cp -f build/library.swf build/android/library.swf
	cp -f build/library.swf build/default/library.swf
	cp -f flex/AirTestFairy/src/com/testfairy/extension.xml build/extension.xml
	cp -f flex/AirTestFairy/src/com/testfairy/platformoptions.xml build/platformoptions.xml
	airsdk/bin/adt -package -target ane build/AirTestFairy.ane build/extension.xml -swc build/AirTestFairy.swc -platform iPhone-ARM -C build/ios . -platformoptions build/platformoptions.xml -platform Android-ARM -C build/android . -platform default -C build/default .

clean:
	-rm -rf build 
	-rm ios/AirTestFairy/AirTestFairy/TestFairy.h
	-rm ios/AirTestFairy/AirTestFairy/libTestFairy.a
	-rm -rf airsdk
