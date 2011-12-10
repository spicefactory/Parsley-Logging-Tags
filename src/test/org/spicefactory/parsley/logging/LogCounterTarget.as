package org.spicefactory.parsley.logging {
import mx.logging.AbstractTarget;
import mx.logging.ILogger;
import mx.logging.LogEvent;

import flash.utils.Dictionary;

public class LogCounterTarget extends AbstractTarget {

	
	private static var counter:Dictionary = new Dictionary();
	

	function LogCounterTarget () {
		
	}
	
	public override function logEvent (event:LogEvent) : void {
		var loggerName:String = ILogger(event.target).category;
		if (counter[loggerName] == undefined) {
			counter[loggerName] = 1;
		} else {
			counter[loggerName]++;
		}		
	}		
	
	
	public static function reset () : void {
		counter = new Dictionary();
	}
	
	public static function getCount (loggerName:String) : uint {
		return (counter[loggerName] == undefined) ? 0 : counter[loggerName];
	}
	
	
	
}

}