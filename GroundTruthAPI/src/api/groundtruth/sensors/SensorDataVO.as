package api.groundtruth.sensors {
	
	[Bindable]
	public class SensorDataVO {
		public var sensor_id:String;
		public var power_usage:Number;
		public var timestamp:String;
		public var appliance_name:String = "N/A";
	}
}