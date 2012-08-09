package plugins.advertising.activities.supportClasses
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.AdCuePointEntry;
	
	public class AdCuePointListEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ITEM_DELETE:String = "itemDelete";
		
		/**
		 * @public
		 */
		public var adCuePoint:AdCuePointEntry;
		
		/**
		 * Constructor
		 */
		public function AdCuePointListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}