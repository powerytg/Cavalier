package frameworks.cavalier.app.env
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Environment extends EventDispatcher
	{
		/**
		 * Constructor
		 */
		public function Environment(target:IEventDispatcher=null)
		{
			super(target);
			throw(new Error("Attempting to initialize a singleton class"));
		}
		
		/**
		 * @public
		 */
//		public static var serverUrl:String = "http://ec2-107-20-31-169.compute-1.amazonaws.com";
		public static var serverUrl:String = "http://10.58.99.103:3000";
//		public static var serverUrl:String = "http://10.0.1.5:3000";
//		public static var serverUrl:String = "http://ec2-184-73-4-252.compute-1.amazonaws.com:7402";
	}
}