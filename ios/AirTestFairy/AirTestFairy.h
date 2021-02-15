//
//  AirTestFairy.h
//  AirTestFairy
//
//  Created by TestFairy on 3/24/15.
//  Copyright (c) 2015 TestFairy. All rights reserved.
//

#import "FPANEUtils.h"

// C interface
DEFINE_ANE_FUNCTION(AirTestFairyBegin);
DEFINE_ANE_FUNCTION(AirTestFairyPushFeedbackController);
DEFINE_ANE_FUNCTION(AirTestFairySetCorrelationId);
DEFINE_ANE_FUNCTION(AirTestFairyPause);
DEFINE_ANE_FUNCTION(AirTestFairyResume);
DEFINE_ANE_FUNCTION(AirTestFairyGetSessionUrl);
DEFINE_ANE_FUNCTION(AirTestFairyTakeScreenshot);
DEFINE_ANE_FUNCTION(AirTestFairyLog);
DEFINE_ANE_FUNCTION(AirTestFairyIdentify);
DEFINE_ANE_FUNCTION(AirTestFairySetUserId);
DEFINE_ANE_FUNCTION(AirTestFairySetAttribute);
DEFINE_ANE_FUNCTION(AirTestFairySetServerEndpoint);
DEFINE_ANE_FUNCTION(AirTestFairySendUserFeedback);
DEFINE_ANE_FUNCTION(AirTestFairyCheckpoint);
DEFINE_ANE_FUNCTION(AirTestFairySetScreenName);
DEFINE_ANE_FUNCTION(AirTestFairyStop);

// ANE Setup
void AirTestFairyContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void AirTestFairyContextFinalizer(FREContext ctx);
void AirTestFairyInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void AirTestFairyFinalizer(void *extData);