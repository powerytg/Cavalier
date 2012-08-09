package ui.messagePanel.events
{
	import flash.events.Event;
	
	public class MessagePanelEvent extends Event
	{
		/**
		 * @public
		 */
		public static const MESSAGE_PANEL_CLOSE:String = "messagePanelClose";
		
		/**
		 * Constructor
		 */
		public function MessagePanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}