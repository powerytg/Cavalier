package plugins.videoMetrics.parts.core
{
	import flash.utils.getTimer;
	
	import frameworks.cavalier.app.events.MetricsEvent;
	
	import mx.charts.chartClasses.ChartBase;
	import mx.collections.ArrayCollection;
	
	
	/**
	 * 
	 * 
	 * @author Nathan Weber
	 */
	public class BaseChartWidget extends VideoMetricsUIPartBase
	{
		
		private static const MAX_POINTS:int = 20;
		
		[SkinPart(required="true")]
		public var chart:ChartBase;
		
		private var points:ArrayCollection;
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public function reset():void {
			points.removeAll();
		}
		
		//----------------------------------------
		//
		// Internal Methods
		//
		//----------------------------------------
		
		/**
		 * Generates an object representing a data point to display on the chart.
		 *  
		 * @param time The current time in milliseconds.
		 * @return 
		 */		
		protected function generatePoint( time:Number ):Object {
			return null;
		}
		
		protected function updateSkinParts():void
		{
			metricsChanged = false;
		}
		
		//----------------------------------------
		//
		// Handlers
		//
		//----------------------------------------
		
		/**
		 * Called when the metrics have updated.
		 *  
		 * @param event
		 */		
		override protected function onMetricsUpdate( event:MetricsEvent ):void {
			
			updateSkinParts();
			
			var p:Object = generatePoint( getTimer() );
			
			if ( p ) {
				points.addItem( p );
				
				while ( points.length > MAX_POINTS ) {
					points.removeItemAt( 0 );
				}
			}
		}
		
		//----------------------------------------
		//
		// Lifecycle
		//
		//----------------------------------------
		
		/**
		 * @private 
		 */		
		override protected function partAdded( partName:String, instance:Object ):void {
			super.partAdded( partName, instance );
			
			if ( instance == chart ) {
				points = new ArrayCollection()
				chart.dataProvider = points;
			}
		}
		
		/**
		 * @private 
		 */		
		override protected function partRemoved( partName:String, instance:Object ):void {
			super.partRemoved( partName, instance );
			
			if ( instance == chart ) {
				chart.dataProvider = null;
				points = null;
			}
		}
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */		
		public function BaseChartWidget() {
			super();
		}
	}
}