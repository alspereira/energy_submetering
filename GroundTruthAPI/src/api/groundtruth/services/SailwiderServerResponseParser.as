package api.groundtruth.services {
	import api.groundtruth.sensors.SensorDataVO;
	
	import mx.collections.ArrayCollection;
	
	public class SailwiderServerResponseParser implements IServerResponseParser {

		public function toArray(response:Object):ArrayCollection {
			var sensorData:ArrayCollection = new ArrayCollection();
			var sensorDataVO:SensorDataVO;
			var xmlData:XML;
			var children:XMLList;
			var powerUsage:String;
			if(!(response is XML))
				return null;
			
			xmlData = new XML(response);
			children = xmlData.children();
			
			for(var i:int = 0; i < children.length(); i = i + 4) {
				if(children[i] != "--") {
					sensorDataVO = new SensorDataVO;
					sensorDataVO.sensor_id = children[i];
					powerUsage =  children[i+1];
					sensorDataVO.power_usage = Number(powerUsage.substring(0, powerUsage.length-1));
					sensorDataVO.timestamp = new Date().toString();
					sensorData.addItem(sensorDataVO);
				}
			}
			return sensorData;
		}
	}
}