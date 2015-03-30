VERSION=1.4.0
CONFIGURATION=Release

all: libTestFairy.a libAirTestFairy.a AIRSDK AirTestFairy.swc AirTestFairy.ane

build: libAirTestFairy.a AirTestFairy.swc AirTestFairy.ane

libTestFairy.a:
	curl -s -o ./ios/AirTestFairy/AirTestFairy/sdk.zip "http://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}.zip"
	unzip -q -o -d ./ios/AirTestFairy/AirTestFairy ./ios/AirTestFairy/AirTestFairy/sdk.zip libTestFairy.a TestFairy.h
	-rm -f ./ios/AirTestFairy/AirTestFairy/sdk.zip
	
libAirTestFairy.a:
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphoneos
	xcodebuild -project ./ios/AirTestFairy/AirTestFairy.xcodeproj -configuration $(CONFIGURATION) -sdk iphonesimulator
	mkdir -p ios/build/$(CONFIGURATION)-universal
	lipo -create ios/AirTestFairy/build/$(CONFIGURATION)-iphoneos/libAirTestFairy.a ios/AirTestFairy/build/$(CONFIGURATION)-iphonesimulator/libAirTestFairy.a -output ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a
	cp -f ios/build/$(CONFIGURATION)-universal/libAirTestFairy.a build/ios/libAirTestFairy.a

AIRSDK:
	rm -rf bin
	mkdir bin
	wget -P bin http://airdownload.adobe.com/air/mac/download/latest/AIRSDK_Compiler.tbz2
	tar xf bin/AIRSDK_Compiler.tbz2 -C ./bin
  
AirTestFairy.swc:
	bin/bin/compc -source-path flex/AirTestFairy/src -output build/AirTestFairy.swc -swf-version=14 -external-library-path+=bin/frameworks/libs/air/airglobal.swc -include-classes com.testfairy.AirTestFairy
  
AirTestFairy.ane:  
	unzip -o -d build build/AirTestFairy.swc library.swf
	cp -f build/library.swf build/ios/library.swf
	cp -f build/library.swf build/default/library.swf
	bin/bin/adt -package -target ane build/AirTestFairy.ane build/extension.xml -swc build/AirTestFairy.swc -platform iPhone-ARM -C build/ios . -platformoptions build/platformoptions.xml -platform default -C build/default .
