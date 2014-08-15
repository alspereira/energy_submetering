package api.groundtruth.events {
	import flash.events.Event;
	
	public class HTTPSensorServiceUnavailable extends Event {
		
		public static const ON_HTTP_SENSOR_SERVICE_UNAVAILABLE:String = "onHTTPSensorServiceUnavailable";
		
		public function HTTPSensorServiceUnavailable(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}