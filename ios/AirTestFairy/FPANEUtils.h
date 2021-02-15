#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject fn(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

void FPANE_DispatchEvent(FREContext context, NSString *eventName);
void FPANE_DispatchEventWithInfo(FREContext context, NSString *eventName, NSString *eventInfo);
void FPANE_Log(FREContext context, NSString *message);

NSString * FPANE_FREObjectToNSString(FREObject object);
BOOL FPANE_FREObjectToBOOL(FREObject object);
NSInteger FPANE_FREObjectToNSInteger(FREObject object);
double FPANE_FREObjectToDouble(FREObject object);

NSArray * FPANE_FREObjectToNSArrayOfNSString(FREObject object);
NSDictionary * FPANE_FREObjectsToNSDictionaryOfNSString(FREObject keys, FREObject values);

FREObject FPANE_BOOLToFREObject(BOOL boolean);
FREObject FPANE_NSStringToFREOBject(NSString *string);