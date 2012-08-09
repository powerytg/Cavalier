package frameworks.cavalier.plugin.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.plugin.Plugin;
	
	public class PluginManagerEvent extends Event
	{
		/**
		 * @public
		 */
		public static const PLUGIN_LOADED:String = "pluginLoaded";
		
		/**
		 * @public
		 */
		public static const PLUGIN_INITIALIZED:String = "pluginInitialized";
		
		/**
		 * @public
		 */
		public var plugin:Plugin;
		
		/**
		 * Constructor
		 */
		public function PluginManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}