package frameworks.cavalier.messaging.models
{
	import flash.events.IEventDispatcher;
	
	public class TextMessage extends MessageBase
	{
		/**
		 * @public
		 */
		[Bindable]
		public var content:String;
		
		/**
		 * Constructor
		 */
		public function TextMessage(_content:String = null)
		{
			super();
			
			content = _content;
		}
	}
}