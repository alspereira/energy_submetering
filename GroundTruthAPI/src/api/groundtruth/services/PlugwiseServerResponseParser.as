package api.groundtruth.services {
	import api.groundtruth.sensors.SensorDataVO;
	
	import mx.collections.ArrayCollection;
	
	public class PlugwiseServerResponseParser implements IServerResponseParser {

		public function toArray(response:Object):ArrayCollection {
			var sensorData:ArrayCollection = new ArrayCollection();
			var xmlData:XML;
			var sensorDataVO:SensorDataVO;
			
			if(!(response is XML))
				return null;
			
			xmlData = new XML(response);
			
			for each(var module:Object in xmlData.appliance) {
				sensorDataVO = new SensorDataVO();
				sensorDataVO.sensor_id = module.module_id;
				sensorDataVO.power_usage = Math.max(0, module.powerusage);
				sensorDataVO.timestamp = module.timestamp;
				sensorData.addItem(sensorDataVO);
			}
			
			return sensorData;
		}
	}
}