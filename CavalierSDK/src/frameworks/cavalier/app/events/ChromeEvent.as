package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.crescent.activity.Activity;
	
	public class ChromeEvent extends Event
	{
		/**
		 * @public
		 */
		public static const SELECT_ACTIVITY:String = "selectActivity";
		
		/**
		 * @public
		 */
		public var activity:Activity;
		
		/**
		 * @public
		 */
		public static const CHANGE_BACKGROUND:String = "changeBackground";
		
		/**
		 * @public
		 */
		public static const SHOW_BACKGROUND:String = "showBackground";

		/**
		 * @public
		 */
		public static const HIDE_BACKGROUND:String = "hideBackground";

		/**
		 * @public
		 */
		public static const RESET_BACKGROUND:String = "resetBackground";

		/**
		 * @public
		 */
		public var backgroundFace:Object;
		
		/**
		 * Constructor
		 */
		public function ChromeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}