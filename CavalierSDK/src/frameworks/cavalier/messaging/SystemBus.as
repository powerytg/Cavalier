package frameworks.cavalier.messaging
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.messaging.events.MessageEvent;
	import frameworks.cavalier.messaging.events.SystemBusEvent;
	import frameworks.cavalier.messaging.models.Log;
	import frameworks.cavalier.messaging.models.MessageBase;
	import frameworks.cavalier.messaging.models.MessageLevel;
	import frameworks.cavalier.messaging.models.MessageStatus;
	import frameworks.cavalier.messaging.models.TextMessage;
	import frameworks.cavalier.ui.messaging.IndicatorBase;
	
	import mx.collections.ArrayCollection;
	
	public class SystemBus extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var activeMessages:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var inactiveMessages:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var alwaysOnMessages:ArrayCollection = new ArrayCollection();

		/**
		 * @private
		 */
		private static var _systemBus:SystemBus;
		
		/**
		 * @private
		 */
		public static function get systemBus():SystemBus
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():SystemBus
		{
			if (_systemBus == null){
				_systemBus = new SystemBus();
			}
			return _systemBus;
		}
		
		/**
		 * @constructor
		 */
		public function SystemBus()
		{
			super();
			if( _systemBus != null ) throw new Error("Error:SystemBus already initialised.");
			if( _systemBus == null ) _systemBus = this;
			
			// Listeners
			_systemBus.addEventListener(MessageEvent.STATUS_CHANGE, onMessageStatusChange, false, 0, true);
		}
		
		/**
		 * @private
		 */
		protected function onMessageStatusChange(evt:MessageEvent):void{
			var message:MessageBase = evt.message;
			if(evt.newStatus == MessageStatus.INACTIVE){
				if(activeMessages.contains(message))
					activeMessages.removeItemAt(activeMessages.getItemIndex(message));
				
				if(!inactiveMessages.contains(message))
					inactiveMessages.addItem(message);
			}
			else if(evt.newStatus == MessageStatus.ACTIVE){
				if(inactiveMessages.contains(message))
					inactiveMessages.removeItemAt(inactiveMessages.getItemIndex(message));
				
				if(!activeMessages.contains(message))
					activeMessages.addItem(message);					
			}
		}
		
		/**
		 * @public
		 */
		public function newTextMessage(content:String, level:String = MessageLevel.NORMAL):TextMessage{
			var message:TextMessage = new TextMessage(content);
			message.level = level;
			activeMessages.addItem(message);
			
			var evt:SystemBusEvent = new SystemBusEvent(SystemBusEvent.NEW_MESSAGE);
			evt.message = message;
			dispatchEvent(evt);
			
			return message;
		}
		
		/**
		 * @public
		 */
		public function newMessage(message:MessageBase):MessageBase{
			switch(message.status){
				case MessageStatus.ALWAYS_ON:
					alwaysOnMessages.addItem(message);
					break;
				case MessageStatus.ACTIVE:
					activeMessages.addItem(message);
					break;
				case MessageStatus.INACTIVE:
					activeMessages.addItem(message);
					break;
			}
			
			var evt:SystemBusEvent = new SystemBusEvent(SystemBusEvent.NEW_MESSAGE);
			evt.message = message;
			dispatchEvent(evt);

			return message;
		}
	
		/**
		 * public
		 */
		public function newLog(content:String, level:String = MessageLevel.NORMAL):Log{
			var log:Log = new Log(content);
			log.level = level;
			inactiveMessages.addItem(log);
			
			var evt:SystemBusEvent = new SystemBusEvent(SystemBusEvent.NEW_MESSAGE);
			evt.message = log;
			dispatchEvent(evt);

			return log;
		}
		
		/**
		 * @public
		 */
		public function newIndicator(indicator:IndicatorBase):void{
			var evt:SystemBusEvent = new SystemBusEvent(SystemBusEvent.ADD_INDICATOR_REQUEST);
			evt.indicator = indicator;
			dispatchEvent(evt);
		}

		/**
		 * @public
		 */
		public function removeIndicator(indicator:IndicatorBase):void{
			var evt:SystemBusEvent = new SystemBusEvent(SystemBusEvent.REMOVE_INDICATOR_REQUEST);
			evt.indicator = indicator;
			dispatchEvent(evt);
		}

		/**
		 * @public
		 */
		public function clearAllActiveMessages():void{
			var messages:Array = [];
			
			for each(var message:MessageBase in activeMessages){
				messages.push(message);
			}
			
			for each(message in messages){
				message.status = MessageStatus.INACTIVE;
			}

		}
		
	}
}