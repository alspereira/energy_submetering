package api.groundtruth.sensors {
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Sensor {
		
		public var sensor_id:String;
		public var power_usage:Number;
		public var timestamp:String;
		public var history:ArrayCollection;
		
		private var historySize:int;
		
		public function Sensor(sensor_id:String, historySize:int = 60) {
			history = new ArrayCollection();
			this.historySize = historySize;
			this.sensor_id = sensor_id;
		}
		
		public function updateSensor(sensorData:SensorDataVO) : void {
			power_usage = sensorData.power_usage;
			timestamp = sensorData.timestamp;
			if(history.length < historySize) {
				history.addItem(sensorData);		
			}
			else {
				history.removeItemAt(0);
				history.addItem(sensorData);
			}
		}
	}
}