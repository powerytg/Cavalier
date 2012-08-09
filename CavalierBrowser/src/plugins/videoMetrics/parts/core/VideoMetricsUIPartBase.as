package plugins.videoMetrics.parts.core
{
	import frameworks.cavalier.app.events.MetricsEvent;
	import frameworks.cavalier.app.models.videoMetrics.BaseMetrics;
	import frameworks.cavalier.app.models.videoMetrics.VideoMetrics;
	import frameworks.cavalier.ui.parts.UIPart;
	
	import mx.events.FlexEvent;
	
	public class VideoMetricsUIPartBase extends UIPart
	{
		/**
		 * @private
		 */
		protected var _metrics:VideoMetrics;
		 
		/**
		 * @private
		 */
		protected var metricsChanged:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function VideoMetricsUIPartBase()
		{
			super();
		}
		
		/**
		 * private
		 */
		public function get metrics():VideoMetrics
		{
			return _metrics;
		}

		/**
		 * @private
		 */
		public function set metrics(value:VideoMetrics):void
		{
			if ( _metrics == value ) {
				return;
			}
			
			if ( _metrics ) {
				_metrics.removeEventListener( MetricsEvent.UPDATE, onMetricsUpdate );
			}
			
			_metrics = value;
			
			if ( _metrics ) {
				_metrics.addEventListener( MetricsEvent.UPDATE, onMetricsUpdate, false, 0, true );
			}
			
			metricsChanged = true;
		}

		/**
		 * @private
		 */
		override protected function onCreationComplete(evt:FlexEvent):void{
			super.onCreationComplete(evt);
			
			localMessageBus.addEventListener(MetricsEvent.READY, onMetricsReady);
			requestVideoMetrics();
		}
		
		/**
		 * @private
		 */
		protected function requestVideoMetrics():void{
			localMessageBus.dispatchEvent(new MetricsEvent(MetricsEvent.REQUEST_METRICS));
		}
		
		/**
		 * @private
		 */
		protected function onMetricsReady(evt:MetricsEvent):void{
			metrics = evt.metrics;
		}
		
		/**
		 * @private
		 */
		protected function onMetricsUpdate(evt:MetricsEvent):void{
			// Do nothing in base class
		}
		
	}
}