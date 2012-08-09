package frameworks.cavalier.ui.components.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.ui.components.supportClasses.ITimelineMarkerMetadata;
	
	public class TimelineEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ITEM_DROP:String = "itemDrop";
		
		/**
		 * @public
		 */
		public static const ITEM_MOVE:String = "itemMove";

		/**
		 * @public
		 */
		public static const ITEM_RESIZE:String = "itemResize";

		/**
		 * @public
		 */
		public static const ITEM_SELECT:String = "itemSelect";
		
		/**
		 * @public
		 */
		public var markerMetadata:ITimelineMarkerMetadata;
		
		/**
		 * @public
		 */
		public var time:Number;
		
		/**
		 * Constructor
		 */
		public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}