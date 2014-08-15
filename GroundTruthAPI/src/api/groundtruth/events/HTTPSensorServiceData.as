package api.groundtruth.events {
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class HTTPSensorServiceData extends Event {
		
		public static const ON_HTTP_SENSOR_SERVICE_DATA:String = "onHTTPSensorServiceData";
		
		private var sensorData:ArrayCollection;
		
		public function HTTPSensorServiceData(type:String, sensorData:ArrayCollection, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.sensorData = sensorData;
		}
		
		public function getSensorData():ArrayCollection {
			return sensorData;
		}
	}
}