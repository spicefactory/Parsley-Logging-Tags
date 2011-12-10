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

import org.spicefactory.lib.logging.LogLevel;
import org.spicefactory.lib.reflect.Converters;
import org.spicefactory.parsley.xml.mapper.XmlConfigurationNamespaceRegistry;

/**
 * Provides a static method to initalize the Flash Logging XML tag extension.
 * 
 * @author Jens Halm
 */
public class SpicelibLoggingXmlSupport {
	
	
	/**
	 * The XML Namespace of the Flash Logging tag extension.
	 */
	public static const FLASH_LOGGING_NAMESPACE:String = "http://www.spicefactory.org/parsley/flash/logging";
	
	private static var initialized:Boolean = false;
	
	/**
	 * Initializes the Flash Logging XML tag extension.
	 * Must be invoked before the <code>XmlContextBuilder</code> is used for the first time.
	 */
	public static function initialize () : void {
		if (initialized) return;
		Converters.addConverter(LogLevel, new LogLevelConverter());
		XmlConfigurationNamespaceRegistry
			.getNamespace(FLASH_LOGGING_NAMESPACE)
			.mappedClasses(LogFactoryTag, AppenderTag, LoggerTag);
		initialized = true;
	}
	
}
}

import org.spicefactory.lib.logging.LogLevel;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.parsley.core.errors.ContextError;

import flash.system.ApplicationDomain;

class LogLevelConverter implements Converter {
	
	public function convert (value:*, domain:ApplicationDomain = null) : * {
		var level:LogLevel = LogLevel[value.toString().toUpperCase()];
		if (level == null) {
			throw new ContextError("Illegal value for log level: " + value);
		}
		return level;
	}

}