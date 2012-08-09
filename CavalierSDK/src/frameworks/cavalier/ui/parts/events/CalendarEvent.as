package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	public class CalendarEvent extends Event
	{
		/**
		 * @public
		 */
		public static const PLAYLIST_DATE_CHANGE:String = "playlistDateChange";

		/**
		 * @public
		 */
		public static const CLIP_DATE_CHANGE:String = "clipDateChange";

		/**
		 * @public
		 */
		public var selectedItem:Object;
		
		/**
		 * Constructor
		 */
		public function CalendarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}