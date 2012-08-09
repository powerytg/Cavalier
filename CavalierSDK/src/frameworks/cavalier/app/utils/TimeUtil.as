package frameworks.cavalier.app.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class TimeUtil extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function TimeUtil(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function getTimeCode(value:Number):String{
			var minutes:int = value / 60;
			var seconds:int = value % 60;
			
			var minString:String;
			if(minutes < 10)
				minString = "0" + minutes.toString();
			else
				minString = minutes.toString();
			
			var secString:String;
			if(seconds < 10)
				secString = "0" + seconds.toString();
			else
				secString = seconds.toString();
			
			return minString + ":" + secString;
		}

	}
}