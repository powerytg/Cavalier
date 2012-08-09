package frameworks.cavalier.app.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MathUtils extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function MathUtils(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function randomRange(low:Number=0, high:Number=1):Number{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
	}
}