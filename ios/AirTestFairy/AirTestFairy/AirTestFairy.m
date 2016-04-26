
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
	NSMutableDictionary *identityTraits = [[NSMutableDictionary alloc] init];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
	[dateFormatter setLocale:[NSLocale currentLocale]];

	NSArray *attributesArray = [traitString componentsSeparatedByString:@"\n"];
	for (int i = 0; i < [attributesArray count]; i++) {
		NSString *keyValuePair = [attributesArray objectAtIndex:i];
		NSRange range = [keyValuePair rangeOfString:@"="];
		if (range.location != NSNotFound) {
			NSString *unescapedKey = [keyValuePair substringToIndex:range.location];
			NSString *key =[[unescapedKey stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSString *valueProperty = [keyValuePair substringFromIndex:range.location+1];
			NSRange position = [valueProperty rangeOfString:@"/"];
			if (position.location != NSNotFound) {
				NSString *type = [valueProperty substringToIndex:position.location];
				NSString *unescapedValue = [valueProperty substringFromIndex:position.location + 1];
				NSString *escapedValue = [[unescapedValue stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				[identityTraits setObject:escapedValue forKey:key];
			}
		}
	}

	[TestFairy identify:correlationId traits:identityTraits];
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
		@"identify": [NSValue valueWithPointer:&AirTestFairyIdentify]
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
