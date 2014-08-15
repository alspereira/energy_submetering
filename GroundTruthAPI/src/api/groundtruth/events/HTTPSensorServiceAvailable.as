package api.groundtruth.events {
	import flash.events.Event;
	
	public class HTTPSensorServiceAvailable extends Event {
		
		public static const ON_HTTP_SENSOR_SERVICE_AVAILABLE:String = "onHTTPSensorServiceAvailable";
		
		public function HTTPSensorServiceAvailable(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}