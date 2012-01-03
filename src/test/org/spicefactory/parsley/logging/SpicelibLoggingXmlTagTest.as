package org.spicefactory.parsley.logging {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.context.ContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.logging.spicelib.SpicelibLoggingXmlSupport;
import org.spicefactory.parsley.xml.XmlConfig;

public class SpicelibLoggingXmlTagTest {
	
	
	private static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley"
		xmlns:log="http://www.spicefactory.org/parsley/flash/logging"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://www.spicefactory.org/parsley http://www.spicefactory.org/parsley/schema/2.0/parsley-core.xsd http://www.spicefactory.org/parsley/flash/logging http://www.spicefactory.org/parsley/schema/2.0/parsley-logging-flash.xsd"
		>
		<log:factory id="logFactory">
			<log:appender ref="appender" threshold="trace"/>
			<log:logger name="foo" level="warn"/>
			<log:logger name="foo.bar" level="off"/>
			<log:logger name="log.debug" level="debug"/>
			<log:logger name="log.info" level="info"/>
			<log:logger name="log.error" level="error"/>
			<log:logger name="log.fatal" level="fatal"/>
		</log:factory>
		<object id="appender" type="org.spicefactory.parsley.logging.LogCounterAppender"/>
	</objects>;
	
	
	[Test]
	public function testLogFactoryConfig () : void {
		SpicelibLoggingXmlSupport.initialize();
		var context:Context = ContextBuilder.newBuilder().config(XmlConfig.forInstance(config)).build();
		var app:LogCounterAppender = context.getObjectByType(LogCounterAppender) as LogCounterAppender;
		logAllLevels(app);
	}
	
	
	private function logAllLevels (counter:LogCounterAppender) : void {
		basicLoggerTest(counter, "foo", 3);
		basicLoggerTest(counter, "foo.bar", 0);
		basicLoggerTest(counter, "foo.other", 3);
		basicLoggerTest(counter, "other", 6);
		basicLoggerTest(counter, "log.debug", 5);
		basicLoggerTest(counter, "log.info", 4);
		basicLoggerTest(counter, "log.error", 2);
		basicLoggerTest(counter, "log.fatal", 1);
	}
	
	private function basicLoggerTest (counter:LogCounterAppender, 
			name:String, count:uint) : void {
		var msg:String = "The message does not matter";
		var logger:Logger = LogContext.getLogger(name);
		logger.trace(msg);
		logger.debug(msg);
		logger.info(msg);
		logger.warn(msg);
		logger.error(msg);
		logger.fatal(msg);
		assertThat(counter.getCount(name), equalTo(count));
	}
	
	
}

}