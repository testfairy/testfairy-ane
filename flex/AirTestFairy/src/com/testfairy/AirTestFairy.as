package com.testfairy
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	public class AirTestFairy
	{
		public static function get isSupported():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}
		
		public static function begin():void
		{
			traceLog("TESTFAIRY LOG");
			
			call("begin");
		}
		
		public static function pushFeedbackController():void
		{
			traceLog("TESTFAIRY LOG");

			call("pushFeedbackController");
		}
			
		public static function setCorrelationId(value:String):void
		{
			traceLog("TESTFAIRY LOG");

			if (value)
			{
				call("setCorrelationId", value);
			}
		}

		public static function getSessionUrl():String
		{
			traceLog("TESTFAIRY LOG");

			return call("getSessionUrl");
		}
		
		public static function pause():void
		{
			traceLog("TESTFAIRY LOG");

			call("pause");
		}
		
		public static function resume():void
		{
			traceLog("TESTFAIRY LOG");

			call("resume");
		}
		
		public static function takeScreenshot():void
		{
			traceLog("TESTFAIRY LOG");

			call("takeScreenshot");
		}
		
		public static function log(value:String):void
		{
			traceLog("TESTFAIRY LOG");

			if (value)
			{
				call("log", value);
			}
		}
	
		private static const EXTENSION_ID : String = "com.testfairy";
		
		private static var _context : ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
		
		private static function call(...args):*
		{
			if (!isSupported) return null;
			
			if (!_context) throw new Error("Extension context is null. Please check if extension.xml is setup correctly.");
			
			return _context.call.apply(_context, args);
		}

		private static function traceLog(msg:String):void
		{
			trace("Adam" + msg);
		}
	}
}