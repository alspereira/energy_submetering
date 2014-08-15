package api.groundtruth.services {
	import api.groundtruth.config.HTTPServiceConfig;
	import api.groundtruth.events.HTTPSensorServiceAvailable;
	import api.groundtruth.events.HTTPSensorServiceData;
	import api.groundtruth.events.HTTPSensorServiceUnavailable;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.osmf.events.TimeEvent;

	[Event(name="onHTTPSensorServiceAvailable", type="api.groundtruth.events.HTTPSensorServiceAvailable")]
	[Event(name="onHTTPSensorServiceUnavailable", type="api.groundtruth.events.HTTPSensorServiceUnavailable")]
	[Event(name="onHTTPSensorServiceData", type="api.groundtruth.events.HTTPSensorServiceData")]
	public class HTTPSensorService extends EventDispatcher {
		
		private var httpServiceConfig:HTTPServiceConfig;
		private var serverResponseParser:IServerResponseParser;
		
		private var httpService:HTTPService;
		private var requestTimer:Timer;
		
		private var isServiceAvailable:Boolean = false;
		
		public function HTTPSensorService(httpServiceConfig:HTTPServiceConfig, serverResponseParser:IServerResponseParser) {
			this.serverResponseParser = serverResponseParser;
			this.httpServiceConfig = httpServiceConfig;
			this.requestTimer = new Timer(httpServiceConfig.QUERY_TIME_INTERVAL);
			this.requestTimer.addEventListener(TimerEvent.TIMER, onRequestTime);
		}
		
		public function start() : void {
			echoServer();
		}
		
		public function stop() : void {
			requestTimer.stop();
			//requestTimer.removeEventListener(TimerEvent.TIMER, onRequestTime);
		}
		
		private function echoServer():void {
			httpService = new HTTPService();
			httpService.resultFormat = 'e4x';
			httpService.method = 'GET';
			httpService.url = httpServiceConfig.SERVER_BASE_URL + "/" + httpServiceConfig.ECHO_URL + "&rnd=" + requestTimer.currentCount;
			trace(httpService.url);
			httpService.addEventListener(ResultEvent.RESULT, onEchoServerResult);
			httpService.addEventListener(FaultEvent.FAULT, onEchoServerFault);
			httpService.send();
		}
		
		private function queryServer():void {
			httpService = new HTTPService();
			httpService.resultFormat = 'e4x';
			httpService.method = 'GET';
			httpService.url = httpServiceConfig.SERVER_BASE_URL + "/" + httpServiceConfig.SERVICE_URL + "&rnd=" + requestTimer.currentCount;
			//trace(httpService.url);
			httpService.addEventListener(ResultEvent.RESULT, onQueryServerResult);
			httpService.addEventListener(FaultEvent.FAULT, onQueryServerFault);
			httpService.send();
		}
		
		// handlers
		private function onEchoServerResult(event:ResultEvent):void {
			// cool... server is available
			//httpService.removeEventListener(ResultEvent.RESULT, onEchoServerResult);
			//httpService.removeEventListener(FaultEvent.FAULT, onEchoServerFault);
			
			queryServer();
			
			requestTimer.start();
		}
		
		private function onEchoServerFault(event:FaultEvent):void {
			// damn... server is not available
			echoServer();
		}
		
		private function onQueryServerResult(event:ResultEvent):void {
			// hurray... we have data from the server			
			var sensorData:ArrayCollection = serverResponseParser.toArray(event.result);
			
			var sensorServiceDataEvent:HTTPSensorServiceData = new HTTPSensorServiceData(HTTPSensorServiceData.ON_HTTP_SENSOR_SERVICE_DATA, sensorData);
			dispatchEvent(sensorServiceDataEvent);
			
			if(!isServiceAvailable) {
				isServiceAvailable = true;
				var sensorServiceAvailableEvent:HTTPSensorServiceAvailable = new HTTPSensorServiceAvailable(HTTPSensorServiceAvailable.ON_HTTP_SENSOR_SERVICE_AVAILABLE);
				dispatchEvent(sensorServiceAvailableEvent);
			}
		}
		
		private function onQueryServerFault(event:FaultEvent):void {
			// wtf... seems like the server is down
			
			requestTimer.stop();
			//requestTimer.removeEventListener(TimerEvent.TIMER, onRequestTime);
			
			//httpService.removeEventListener(ResultEvent.RESULT, onEchoServerResult);
			//httpService.removeEventListener(FaultEvent.FAULT, onEchoServerFault);
			
			var sensorServiceUnavailableEvent:HTTPSensorServiceUnavailable = new HTTPSensorServiceUnavailable(HTTPSensorServiceUnavailable.ON_HTTP_SENSOR_SERVICE_UNAVAILABLE);	
			dispatchEvent(sensorServiceUnavailableEvent);
			
			isServiceAvailable = false;
			echoServer();
		}
		
		private function onRequestTime(event:TimerEvent):void {
			queryServer();
		}
	}
}