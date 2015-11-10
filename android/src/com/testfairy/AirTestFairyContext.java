package com.testfairy;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import java.util.HashMap;
import java.util.Map;

public class AirTestFairyContext extends FREContext {
	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		functions.put("begin", new Begin());
		functions.put("pushFeedbackController", new PushFeedbackController());
		functions.put("setCorrelationId", new SetCorrelationId());
		functions.put("getSessionUrl", new GetSessionUrl());
		functions.put("pause", new Pause());
		functions.put("resume", new Resume());
		functions.put("takeScreenshot", new TakeScreenshot());
		functions.put("log", new Logger());
		functions.put("getVersion", new GetVersion());

		return functions;
	}

	@Override
	public void dispose() {

	}

	private static class Begin implements FREFunction {
		@Override
		public FREObject call(FREContext context, FREObject[] freObjects) {
			Context appContext = context.getActivity().getApplicationContext();
			try {
				String apiKey = freObjects[0].getAsString();
				TestFairy.begin(appContext, apiKey);
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to begin TestFairy", exception);
			}

			return null;
		}
	}

	private static class PushFeedbackController implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			return null;
		}
	}

	private static class SetCorrelationId implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				String correlationId = freObjects[0].getAsString();
				TestFairy.setCorrelationId(correlationId);
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to set correlation ID", exception);
			}
			return null;
		}
	}

	private static class GetSessionUrl implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				return FREObject.newObject(TestFairy.getSessionUrl());
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to get session url", exception);
				return null;
			}
		}
	}

	private static class Pause implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				TestFairy.pause();
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to pause TestFairy", exception);
			}
			return  null;
		}
	}

	private static class Resume implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				TestFairy.resume();
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to resume TestFairy", exception);
			}
			return  null;
		}
	}

	private static class TakeScreenshot implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				TestFairy.takeScreenshot();
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to take a screenshot TestFairy", exception);
			}
			return  null;
		}
	}

	private static class Logger implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			return null;
		}
	}

	private static class GetVersion implements FREFunction {
		@Override
		public FREObject call(FREContext freContext, FREObject[] freObjects) {
			try {
				return FREObject.newObject(TestFairy.getVersion());
			} catch (Exception exception) {
				Log.e("AirTestFairyContext", "Failed to get version of TestFairy", exception);
			}
			return  null;
		}
	}
}
