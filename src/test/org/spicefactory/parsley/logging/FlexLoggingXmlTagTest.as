package org.spicefactory.parsley.logging {

import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.logging.flex.FlexLogFactory;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.logging.flex.FlexLoggingXmlSupport;
import org.spicefactory.parsley.xml.XmlConfig;

public class FlexLoggingXmlTagTest {

	
	
	FlexLoggingXmlSupport.initialize();
	
	
	private static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley"
		xmlns:log="http://www.spicefactory.org/parsley/flex/logging"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://www.spicefactory.org/parsley http://www.spicefactory.org/parsley/schema/2.0/parsley-core.xsd http://www.spicefactory.org/parsley/flex/logging http://www.spicefactory.org/parsley/schema/2.0/parsley-logging-flex.xsd"
		>
		<log:target id="debugTarget" type="org.spicefactory.parsley.logging.LogCounterTarget" level="debug">
			<log:filter>log.debug.*</log:filter>		
		</log:target>
		<log:target id="infoTarget" type="org.spicefactory.parsley.logging.LogCounterTarget" level="info">
			<log:filter>log.info.*</log:filter>		
		</log:target>
		<log:target id="warnTarget" type="org.spicefactory.parsley.logging.LogCounterTarget" level="warn">
			<log:filter>foo.*</log:filter>		
		</log:target>
		<log:target id="errorTarget" type="org.spicefactory.parsley.logging.LogCounterTarget" level="error">
			<log:filter>log.error.*</log:filter>		
		</log:target>
		<log:target id="fatalTarget" type="org.spicefactory.parsley.logging.LogCounterTarget" level="fatal">
			<log:filter>log.fatal.*</log:filter>		
		</log:target>
	</objects>;	
	
	
	[Test]
	public function logTargetConfig () : void {
		LogCounterTarget.reset();
		LogContext.factory = new FlexLogFactory(); // not necessary in application code, but this test runs together with Flash Logging Tests
		ContextBuilder.newBuilder().config(XmlConfig.forInstance(config)).build();
		logAllLevels();
	}
	
	
	private function logAllLevels () : void {
		basicLoggerTest("foo", 3);
		basicLoggerTest("foo.other", 3);
		basicLoggerTest("other", 0);
		basicLoggerTest("log.debug", 5);
		basicLoggerTest("log.info", 4);
		basicLoggerTest("log.error", 2);
		basicLoggerTest("log.fatal", 1);
	}
	
	private function basicLoggerTest (name:String, count:uint) : void {
		var msg:String = "The message does not matter";
		var logger:Logger = LogContext.getLogger(name);
		logger.debug(msg);
		logger.info(msg);
		logger.warn(msg);
		logger.error(msg);
		logger.fatal(msg);
		assertThat(LogCounterTarget.getCount(name), equalTo(count));
	}

	
}

}