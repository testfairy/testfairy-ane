
#import "AirTestFairy.h"
#import "TestFairy.h"

static FREContext context;

DEFINE_ANE_FUNCTION(AirTestFairyBegin)
{
	NSString *appToken = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy begin:appToken];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyPushFeedbackController)
{
	[TestFairy pushFeedbackController];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairySendUserFeedback)
{
	NSString *feedback = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy sendUserFeedback:feedback];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairySetCorrelationId)
{
	NSString *correlationId = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy setCorrelationId:correlationId];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyIdentify)
{
	NSString *correlationId = FPANE_FREObjectToNSString(argv[0]);
	NSString *traitString = FPANE_FREObjectToNSString(argv[1]);
	NSDictionary *identityTraits = nil;
	
	@try
	{
		NSError *error;
		NSData *jsonData = [traitString dataUsingEncoding:NSUTF8StringEncoding];
		identityTraits = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
	}
	@catch (NSException* exception)
	{
	}

	if (identityTraits == nil) {
		[TestFairy identify:correlationId];
	} else {
		[TestFairy identify:correlationId traits:identityTraits];
	}
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyPause)
{
	[TestFairy pause];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyResume)
{
	[TestFairy resume];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyGetSessionUrl)
{
	return FPANE_NSStringToFREOBject([TestFairy sessionUrl]);
}

DEFINE_ANE_FUNCTION(AirTestFairyTakeScreenshot)
{
	[TestFairy takeScreenshot];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyLog)
{
	NSString *logText = FPANE_FREObjectToNSString(argv[0]);
	TFLog(@"%@", logText);
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyGetVersion)
{
	return FPANE_NSStringToFREOBject([TestFairy version]);
}


DEFINE_ANE_FUNCTION(AirTestFairySetUserId) {
	NSString *userId = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy setUserId:userId];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairySetAttribute) {
	NSString *key = FPANE_FREObjectToNSString(argv[0]);
	NSString *value = FPANE_FREObjectToNSString(argv[1]);

	return FPANE_BOOLToFREObject([TestFairy setAttribute:key withValue:value]);
}

DEFINE_ANE_FUNCTION(AirTestFairySetServerEndpoint) {
	NSString *endpoint = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy setServerEndpoint:endpoint];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyCheckpoint) {
	NSString *name = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy checkpoint:name];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairySetScreenName) {
	NSString *name = FPANE_FREObjectToNSString(argv[0]);
	[TestFairy setScreenName:name];
	return nil;
}

DEFINE_ANE_FUNCTION(AirTestFairyStop) {
	[TestFairy stop];
	return nil;
}

#pragma mark - ANE Setup

void AirTestFairyContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
	NSDictionary *functions = @{
		@"begin": [NSValue valueWithPointer:&AirTestFairyBegin],
		@"pause": [NSValue valueWithPointer:&AirTestFairyPause],
		@"resume": [NSValue valueWithPointer:&AirTestFairyResume],
		@"takeScreenshot": [NSValue valueWithPointer:&AirTestFairyTakeScreenshot],
		@"pushFeedbackController": [NSValue valueWithPointer:&AirTestFairyPushFeedbackController],
		@"setCorrelationId": [NSValue valueWithPointer:&AirTestFairySetCorrelationId],
		@"getSessionUrl": [NSValue valueWithPointer:&AirTestFairyGetSessionUrl],
		@"log": [NSValue valueWithPointer:&AirTestFairyLog],
		@"sendUserFeedback": [NSValue valueWithPointer:&AirTestFairySendUserFeedback],
		@"getVersion": [NSValue valueWithPointer:&AirTestFairyGetVersion],
		@"identify": [NSValue valueWithPointer:&AirTestFairyIdentify],
		@"setUserId": [NSValue valueWithPointer:&AirTestFairySetUserId],
		@"setAttribute": [NSValue valueWithPointer:&AirTestFairySetAttribute],
		@"setServerEndpoint": [NSValue valueWithPointer:&AirTestFairySetServerEndpoint],
		@"checkpoint": [NSValue valueWithPointer:&AirTestFairyCheckpoint],
		@"setScreenName": [NSValue valueWithPointer:&AirTestFairySetScreenName],
		@"stop": [NSValue valueWithPointer:&AirTestFairyStop],
	};
	
	*numFunctionsToTest = (uint32_t)[functions count];
	
	FRENamedFunction *func = (FRENamedFunction *)malloc(sizeof(FRENamedFunction) * [functions count]);
	
	for (NSInteger i = 0; i < [functions count]; i++)
	{
		func[i].name = (const uint8_t *)[[[functions allKeys] objectAtIndex:i] UTF8String];
		func[i].functionData = NULL;
		func[i].function = [[[functions allValues] objectAtIndex:i] pointerValue];
	}
	
	*functionsToSet = func;
	
	context = ctx;
}

void AirTestFairyContextFinalizer(FREContext ctx) { }

void AirTestFairyInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirTestFairyContextInitializer;
	*ctxFinalizerToSet = &AirTestFairyContextFinalizer;
}

void AirTestFairyFinalizer(void *extData) { }
