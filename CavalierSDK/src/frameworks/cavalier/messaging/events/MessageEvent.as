package frameworks.cavalier.messaging.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.messaging.models.MessageBase;
	
	public class MessageEvent extends Event
	{
		/**
		 * @public
		 */
		public static const STATUS_CHANGE:String = "statusChange";
		
		/**
		 * @public
		 */
		public var message:MessageBase;
		
		/**
		 * @public
		 */
		public var oldStatus:String;
		
		/**
		 * @public
		 */
		public var newStatus:String;
		
		/**
		 * Constructor
		 */
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}