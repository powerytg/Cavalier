package frameworks.cavalier.messaging.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.messaging.models.MessageBase;
	import frameworks.cavalier.ui.messaging.IndicatorBase;
	
	public class SystemBusEvent extends Event
	{
		/**
		 * @public
		 */
		public static const ADD_INDICATOR_REQUEST:String = "addIndicatorRequest";
		
		/**
		 * @public
		 */
		public static const REMOVE_INDICATOR_REQUEST:String = "removeIndicatorRequest";
		
		/**
		 * @public
		 */
		public var indicator:IndicatorBase;

		/**
		 * @public
		 */
		public static const NEW_MESSAGE:String = "newMessage";
		
		/**
		 * @public
		 */
		public static const MESSAGE_READ:String = "messageRead";
		
		/**
		 * @public
		 */
		public var message:MessageBase;
		
		/**
		 * Constructor
		 */
		public function SystemBusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}