package frameworks.cavalier.messaging.events
{
	import flash.events.Event;
	
	public class IndicatorEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ADDED_TO_CHROME:String = "addedToChrome";

		/**
		 * @public
		 */
		public static const REMOVED_FROM_CHROME:String = "removedFromChrome";

		/**
		 * Constructor
		 */
		public function IndicatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}