package frameworks.cavalier.app.models.videoMetrics
{
	import frameworks.cavalier.app.events.MetricsEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class BaseMetrics extends EventDispatcher
	{
		//----------------------------------------
		//
		// Constants
		//
		//----------------------------------------
		
		protected static const DEFAULT_UPDATE_INTERVAL:Number = 100;
		
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private var timer:Timer;
		
		//----------------------------------------
		//
		//	Public Methods
		//
		//----------------------------------------
		
		public function startMetrics():void {
			if ( !timer.running ){
				timer.start();	
			}
		}
		
		public function stopMetrics():void {
			timer.stop();
		}
		
		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------
		
		private function startTimer():void {
			if ( !timer ) {
				timer = new Timer( DEFAULT_UPDATE_INTERVAL );
				timer.addEventListener( TimerEvent.TIMER, handleTimer, false, 0, true );
			}
			
			timer.reset();
		}
		
		private function stopTimer():void {
			if ( timer ) {
				timer.removeEventListener( TimerEvent.TIMER, handleTimer );
				timer.stop();
				timer = null;
			}
		}
		
		/**
		 * Called when the metric's properties should be udpated. 
		 */		
		protected function updateMetrics():void {
			dispatchEvent( new MetricsEvent( MetricsEvent.UPDATE ) );
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		private function handleTimer( event:TimerEvent ):void {
			updateMetrics();
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */		
		public function BaseMetrics() {
			super();
			
			startTimer();
		}
	}
}