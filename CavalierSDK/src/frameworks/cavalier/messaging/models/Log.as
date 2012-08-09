package frameworks.cavalier.messaging.models
{
	import flash.events.IEventDispatcher;
	
	public class Log extends TextMessage
	{
		/**
		 * @public
		 */
		[Bindable]
		public var time:Date;
		
		/**
		 * Constructor
		 */
		public function Log(_content:String, _time:Date = null)
		{
			super(_content);
			
			if(!_time)
				time = new Date();
			else
				time = _time;
		}
	}
}