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

package org.spicefactory.parsley.logging.spicelib {

import org.spicefactory.lib.logging.Appender;
import org.spicefactory.lib.logging.LogLevel;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;

[XmlMapping(elementName="appender")]
/**
 * Represents the appender XML tag.
 * 
 * @author Jens Halm
 */
public class AppenderTag {
	
	
	[Required]
	/**
	 * The id of the refernced appender.
	 */
	public var ref:String;
	
	[Attribute]
	/**
	 * The threshold for the appender.
	 */
	public var threshold:LogLevel = LogLevel.TRACE;
	
	
	/**
	 * Returns the appender, fetching it from the specified context and setting its threshold.
	 * 
	 * @param context the context to fetch the appender from
	 * @return the configured appender instance
	 */
	public function createAppender (context:Context) : Appender {
		var appObj:Object = context.getObject(ref);
		if (!(appObj is Appender)) {
			throw new ContextError("Specified object with id " + ref + " does not implement Appender");
		}
		var app:Appender = appObj as Appender;
		app.threshold = threshold;
		return app;
	}
	
	
}
}
