/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.logging.flex {
import org.spicefactory.lib.logging.flex.FlexLogFactory;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.parsley.core.errors.ContextError;

import mx.logging.ILoggingTarget;
import mx.logging.Log;
import mx.logging.LogEventLevel;
import mx.logging.targets.LineFormattedTarget;
import mx.logging.targets.TraceTarget;

import flash.utils.getQualifiedClassName;

/**
 * Represents the target XML tag, defining a single Flex LogTarget.
 * 
 * @author Jens Halm
 */
public class LogTargetTag {
	
	
	/**
	 * The id of the LogTarget in the Parsley Context. Usually no need to be specified explicitly.
	 */
	public var id:String;
	
	/**
	 * The type of the LogTarget. Defaults to <code>TraceTarget</code>.
	 */
	public var type:Class = TraceTarget;
	
	[ChildTextNode(name="filter")]
	/**
	 * The filters for this LogTarget.
	 */
	public var filters:Array;
	
	/**
	 * The required minimum level for this LogTarget to produce output. Defaults to <code>LogEventLevel.ALL</code>.
	 */
	public var level:int = LogEventLevel.ALL;
	
	
	/**
	 * The field seperator. Only processed for target extending <code>LineFormattedTarget</code>.
	 */
	public var fieldSeparator:String = " ";
	
	/**
	 * Indicates whether the category for this target should be added to the output.
	 */
	public var includeCategory:Boolean = true;
	
	/**
	 * Indicates whether the level for the event should be added to the output.
	 */
	public var includeLevel:Boolean = true;
	
	/**
	 * Indicates whether the date should be added to the output.
	 */
	public var includeDate:Boolean = true;
	
	/**
	 * Indicates whether the time should be added to the output.
	 */
	public var includeTime:Boolean = true;
	
	
	[Factory]
	/**
	 * Creates a new LogTarget based on the properties of this tag class.
	 * 
	 * @return a new LogTarget instance
	 */
	public function createTarget () : ILoggingTarget {
		if (LogContext.factory == null) LogContext.factory = new FlexLogFactory();
		
		var targetObj:Object = new type();
		if (!(targetObj is ILoggingTarget)) {
			throw new ContextError("Object of type " + getQualifiedClassName(targetObj) 
					+ " does not implement ILoggingTarget");
		}
		var target:ILoggingTarget = targetObj as ILoggingTarget;
		if (filters != null) target.filters = filters;
		target.level = level;
		
		if (target is LineFormattedTarget) {
			var lfTarget:LineFormattedTarget = target as LineFormattedTarget;
			lfTarget.fieldSeparator = fieldSeparator;
			lfTarget.includeCategory = includeCategory;
			lfTarget.includeLevel = includeLevel;
			lfTarget.includeDate = includeDate;
			lfTarget.includeTime = includeTime;
		}
		
		Log.addTarget(target);
		return target;
	}
	
	
}
}
