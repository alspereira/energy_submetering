package api.groundtruth.services {
	
	import mx.collections.ArrayCollection;
	
	public interface IServerResponseParser {
		
		function toArray(response:Object):ArrayCollection;
	}
}