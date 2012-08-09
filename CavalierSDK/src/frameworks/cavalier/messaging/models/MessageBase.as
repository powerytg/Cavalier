package frameworks.cavalier.messaging.models
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.messaging.IMessageRenderer;
	import frameworks.cavalier.messaging.SystemBus;
	import frameworks.cavalier.messaging.events.MessageEvent;
	
	public class MessageBase extends EventDispatcher
	{
		/**
		 * @private
		 */
		private var _status:String = MessageStatus.ACTIVE;
		
		/**
		 * @public
		 */
		public var level:String = MessageLevel.NORMAL;
		
		/**
		 * @public
		 */
		public var description:String;
		
		/**
		 * @public
		 */
		public var renderer:Class = null;
		
		/**
		 * Constructor
		 */
		public function MessageBase()
		{
			super();
		}

		/**
		 * @public
		 */
		[Bindable]
		public function get status():String
		{
			return _status;
		}

		/**
		 * @private
		 */
		public function set status(value:String):void
		{
			var oldStatus:String = _status;
			_status = value;
			
			var evt:MessageEvent = new MessageEvent(MessageEvent.STATUS_CHANGE);
			evt.message = this;
			evt.oldStatus = oldStatus;
			evt.newStatus = _status;
			SystemBus.systemBus.dispatchEvent(evt);
		}

	}
}