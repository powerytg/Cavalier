package frameworks.cavalier.ui.parts.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.ui.parts.UIPart;
	
	public class UIPartEvent extends Event
	{
		/**
		 * @public
		 */
		public static const POP_OUT:String = "uiPartPopOut";
		
		/**
		 * @public
		 */
		public var uiPart:UIPart;
		
		/**
		 * Constructor
		 */
		public function UIPartEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}