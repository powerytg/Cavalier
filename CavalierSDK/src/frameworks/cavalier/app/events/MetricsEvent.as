package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.videoMetrics.VideoMetrics;
	
	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class MetricsEvent extends Event
	{
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------
		
		/**
		 * Dispatched when metrics have been updated. 
		 */		
		public static const UPDATE:String = 'metricsUpdate';
		
		/**
		 * @public
		 */
		public static const READY:String = "metricsReady";
		
		/**
		 * @public
		 */
		public static const REQUEST_METRICS:String = "requestMetrics";
		
		/**
		 * @public
		 */
		public var metrics:VideoMetrics;
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor.
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function MetricsEvent( type:String, bubbles:Boolean=false, cancelable:Boolean=false ) {
			super( type, bubbles, cancelable );
		}
	}
}