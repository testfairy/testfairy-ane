package com.testfairy
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class AirTestFairy
	{
		public static function get isSupported():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1 || Capabilities.manufacturer.indexOf("Android") > -1;
		}
		
		public static function begin(appToken:String):void
		{
			if (appToken) {
				call("begin", appToken);
			}
		}
		
		public static function pushFeedbackController():void
		{
			call("pushFeedbackController");
		}
			
		public static function setCorrelationId(value:String):void
		{
			if (value) {
				call("setCorrelationId", value);
			}
		}

		public static function getSessionUrl():String
		{
			return call("getSessionUrl");
		}
		
		public static function pause():void
		{
			call("pause");
		}
		
		public static function resume():void
		{
			call("resume");
		}
		
		public static function takeScreenshot():void
		{
			call("takeScreenshot");
		}
		
		public static function log(value:String):void
		{
			if (value) {
				call("log", value);
			}
		}
		
		public static function getVersion():String
		{
			return call("getVersion");
		}

		public static function identify(correlation:String, options:Object = null):void
		{
			var output:String = "";
			if (options != null) {
				output = JSON.stringify(options);
			}

			call("identify", correlation, output);
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
		}
	}
}
