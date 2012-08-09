package frameworks.cavalier.ui.messaging
{
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.events.IndicatorEvent;
	
	import spark.components.Group;
	
	public class IndicatorBase extends Group
	{
		/**
		 * Constructor
		 */
		public function IndicatorBase()
		{
			super();
			addEventListener(IndicatorEvent.ADDED_TO_CHROME, onAddedToChrome, false, 0, true);
			addEventListener(IndicatorEvent.REMOVED_FROM_CHROME, onRemovedFromChrome, false, 0, true);
		}
		
		/**
		 * @private
		 */
		protected function onAddedToChrome(evt:IndicatorEvent):void{
			removeEventListener(IndicatorEvent.ADDED_TO_CHROME, onAddedToChrome);
		}
		
		/**
		 * @private
		 */
		protected function onRemovedFromChrome(evt:IndicatorEvent):void{
			removeEventListener(IndicatorEvent.REMOVED_FROM_CHROME, onRemovedFromChrome);
		}

		/**
		 * @public
		 */
		public function show():void{
			SystemBus.systemBus.newIndicator(this);
		}

		/**
		 * @public
		 */
		public function close():void{
			SystemBus.systemBus.removeIndicator(this);
		}
	}
}