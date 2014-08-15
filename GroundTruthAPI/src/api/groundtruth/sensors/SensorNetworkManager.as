package api.groundtruth.sensors {
	import mx.collections.ArrayCollection;
	
	// dispatch events
	[Bindable]
	public class SensorNetworkManager {
		
		public var sensors:ArrayCollection;
		
		public function SensorNetworkManager() {
			sensors = new ArrayCollection();
		}
		
		public function updateSensorNetwork(sensorData:ArrayCollection) : void {
			for each(var sensorDataVO:SensorDataVO in sensorData)
				handleSensorData(sensorDataVO);
				
			// sump power and dispatch event with that value
		}
		
		private function handleSensorData(sensorData:SensorDataVO):void {
			var mySensor:Sensor = getSensor(sensorData.sensor_id);
			if( mySensor != null) {
				mySensor.updateSensor(sensorData);
			}
			else {
				mySensor = new Sensor(sensorData.sensor_id);
				mySensor.updateSensor(sensorData);
				sensors.addItem(mySensor);
			}
			
		}
		
		private function sensorExists(sensor_id:String):Boolean {
			for each(var sensor:Sensor in sensors) {
				if(sensor_id == sensor.sensor_id)
					return true;
			}
			return false;
		}
		
		private function getSensor(sensor_id:String):Sensor {
			for each(var sensor:Sensor in sensors) {
				if(sensor_id == sensor.sensor_id)
					return sensor;
			}
			return null;
		}
		
		private function removeAllSensors():void {
			sensors.removeAll();
		}
	}
}
	