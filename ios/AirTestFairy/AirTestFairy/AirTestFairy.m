
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
