package frameworks.cavalier.plugin.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.plugin.Plugin;
	
	public class PluginEvent extends Event
	{
		/**
		 * @public
		 */
		public static const LOADED:String = "loaded";
		
		/**
		 * @public
		 */
		public static const INITIALIZED:String = "initialized";
		
		/**
		 * @public
		 */
		public var plugin:Plugin;
		
		/**
		 * Constructor
		 */
		public function PluginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}