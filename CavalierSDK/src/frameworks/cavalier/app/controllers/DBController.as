package frameworks.cavalier.app.controllers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.app.env.Environment;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class DBController extends EventDispatcher
	{
		
		/**
		 * @private
		 */
		private static var _dbController:DBController;
		
		/**
		 * @private
		 */
		public static function get dbController():DBController
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():DBController
		{
			if (_dbController == null){
				_dbController = new DBController();
			}
			return _dbController;
		}
		
		/**
		 * Constructor
		 */
		public function DBController()
		{
			super();
			if( _dbController != null ) throw new Error("Error:DBController already initialised.");
			if( _dbController == null ) _dbController = this;
		}
		
		/**
		 * @public
		 */
		public function resetDB(successHandler:Function, faultHandler:Function):void{
			var service:HTTPService = new HTTPService();			
			service.url = Environment.serverUrl + "/admin/reset_db";
			service.resultFormat = "text";
			service.addEventListener(ResultEvent.RESULT, function(evt:ResultEvent):void{
				if(successHandler != null)
					successHandler(evt.result as String);
			}, false, 0, true);
			
			// These are one-time only handlers. 
			service.addEventListener(FaultEvent.FAULT, function(evt:FaultEvent):void{
				if(faultHandler != null)
					faultHandler(evt.message);
			}, false, 0, true);
			
			service.send();
		}
		
	}
}