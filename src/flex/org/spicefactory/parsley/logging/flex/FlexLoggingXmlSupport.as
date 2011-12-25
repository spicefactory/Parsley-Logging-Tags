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
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.xml.mapper.XmlConfigurationNamespaceRegistry;

/**
 * Provides a static method to initalize the Flex Logging XML tag extension.
 * Can be used as a child tag of a <code>&lt;ContextBuilder&gt;</code> tag in MXML alternatively.
 * 
 * @author Jens Halm
 */
public class FlexLoggingXmlSupport implements BootstrapConfigProcessor {
	
	
	/**
	 * The XML Namespace of the Flex Logging tag extension.
	 */
	public static const NAMESPACE_URI:String = "http://www.spicefactory.org/parsley/flex/logging";
	
	private static var initialized:Boolean = false;


	/**
	 * Initializes the Flex Logging XML tag extension.
	 * Must be invoked before the <code>XmlContextBuilder</code> is used for the first time.
	 */
	public static function initialize () : void {
		if (initialized) return;
		XmlConfigurationNamespaceRegistry
			.getNamespace(NAMESPACE_URI)
			.newMapperBuilder(LogTargetTag, new QName(NAMESPACE_URI, "target"))
			.addPropertyHandler(new LogEventLevelAttributeHandler(
				ClassInfo.forClass(LogTargetTag).getProperty("level"), new QName("", "level")));
		initialized = true;
	}

	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		initialize();
	}
}
}

import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.mapper.handler.AttributeHandler;
import org.spicefactory.parsley.core.errors.ContextError;

import mx.logging.LogEventLevel;

class LogEventLevelAttributeHandler extends AttributeHandler {
	
	function LogEventLevelAttributeHandler (property:Property, xmlName:QName) {
		super(property, xmlName);
	}
	
	protected override function getValueFromNode (node:XML, context:XmlProcessorContext) : * {
		var value:String = super.getValueFromNode(node, context).toString().toUpperCase();
		if (!(LogEventLevel[value] is int)) {
			throw new ContextError("Illegal value for log event level: " + value);
		}
		return LogEventLevel[value];
	}
	
}
