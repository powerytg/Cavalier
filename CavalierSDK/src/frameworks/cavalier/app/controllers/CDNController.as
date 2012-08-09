package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	import frameworks.cavalier.app.models.CDN;
	import frameworks.cavalier.app.models.ModelStatus;
	import frameworks.cavalier.app.models.sync.Aggregator;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class CDNController extends EventDispatcher
	{
		/**
		 * @private
		 */
		private static var _cdnController:CDNController;
		
		/**
		 * @private
		 */
		public static function get cdnController():CDNController
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():CDNController
		{
			if (_cdnController == null){
				_cdnController = new CDNController();
			}
			return _cdnController;
		}
		
		/**
		 * @constructor
		 */
		public function CDNController()
		{
			super();
			if( _cdnController != null ) throw new Error("Error:CDNController already initialised.");
			if( _cdnController == null ) _cdnController = this;
		}
		
		/**
		 * @public
		 */
		public function parseCDNXml(cdnXml:XMLList):CDN{
			var cdnId:String = String(cdnXml.id);
			var cdnName:String = String(cdnXml.name);
			var cdn:CDN = Aggregator.aggregator.getCDNById(cdnId);
			if(!cdn){
				cdn = new CDN();
				cdn.id = cdnId;
				
				Aggregator.aggregator.cdns.addItem(cdn);
			}
			
			if(cdn.status == ModelStatus.NORMAL){
				cdn.name = cdnName;
			}
			
			return cdn;
		}

		/**
		 * @public
		 */
		public function getAllCDNs():void{
			var service:HTTPService = new HTTPService();
			service.resultFormat = "e4x";
			service.url = Environment.serverUrl + "/admin/get_all_cdn";			
			service.send();			
			
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				log.content = "Tag list retrieved";
				onGetAllCDNs(evt.result as XML);
			});
			
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				log.level = MessageLevel.ALERT;
				log.status = MessageStatus.ACTIVE;
				log.content = "Error while retrieving tags";
			});
			
			var log:Log = SystemBus.systemBus.newLog("Retrieving tag list...");

		}
		
		/**
		 * @private
		 */
		protected function onGetAllCDNs(result:XML):void{			
			for each(var cdnXml:XML in result.cdns.children()){
				var cdnId:String = String(cdnXml.id);
				var cdn:CDN = Aggregator.aggregator.getCDNById(cdnId);
				if(!cdn){
					cdn = new CDN();
					cdn.id = cdnId;
					Aggregator.aggregator.cdns.addItem(cdn);
				}
				
				if(cdn.status == ModelStatus.NORMAL){
					cdn.name = String(cdnXml.name);
				}
			}
		}
		
	}
}