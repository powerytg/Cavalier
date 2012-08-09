package frameworks.cavalier.plugin.managers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.events.PluginEvent;
	import frameworks.cavalier.plugin.events.PluginManagerEvent;
	
	import mx.collections.ArrayCollection;
	
	public class PluginManager extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * All the loaded plugins
		 */
		[Bindable]
		public var plugins:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		private static var _pluginManager:PluginManager;
		
		/**
		 * @public
		 */
		public static function get pluginManager():PluginManager
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():PluginManager
		{
			if (_pluginManager == null){
				_pluginManager = new PluginManager();
			}
			return _pluginManager;
		}
		
		/**
		 * Constructor
		 */
		public function PluginManager()
		{
			super();
			if( _pluginManager != null ) throw new Error("Error:PluginManager already initialised.");
			if( _pluginManager == null ) _pluginManager = this;
		}
		
		/**
		 * @public
		 */
		public function loadPlugin(pluginClass:Class):void{
			var plugin:Plugin = new pluginClass();
			plugin.addEventListener(PluginEvent.LOADED, onPluginLoaded, false, 0, true);
			plugin.addEventListener(PluginEvent.INITIALIZED, onPluginInitialized, false, 0, true);

			// Load and initialize the plugin
			plugin.initialize();
		}
		
		/**
		 * @protected
		 */
		protected function onPluginLoaded(evt:PluginEvent):void{
			var plugin:Plugin = evt.plugin;
			plugin.removeEventListener(PluginEvent.LOADED, onPluginLoaded);
			
			plugins.addItem(plugin);
			
			var event:PluginManagerEvent = new PluginManagerEvent(PluginManagerEvent.PLUGIN_LOADED);
			event.plugin = plugin;
			dispatchEvent(event);
		}
		
		/**
		 * @protected
		 */
		protected function onPluginInitialized(evt:PluginEvent):void{
			var plugin:Plugin = evt.plugin;
			plugin.removeEventListener(PluginEvent.LOADED, onPluginLoaded);
			
			var event:PluginManagerEvent = new PluginManagerEvent(PluginManagerEvent.PLUGIN_INITIALIZED);
			event.plugin = plugin;
			dispatchEvent(event);
			
			// Register UI Parts
			UIPartManager.uiPartManager.registerUIPartsFromPlugin(plugin);
			
			// Register shortcuts
			ShortcutManager.shortcutManager.registerShortcutsFromPlugin(plugin);

			// Register actions
			ActionManager.actionManager.registerShortcutsFromPlugin(plugin);
		}
		
		/**
		 * @public
		 */
		public function getPluginByClass(pluginClass:Class):Plugin{
			for each(var plugin:Plugin in plugins){
				if(plugin is pluginClass)
					return plugin;
			}
			
			return null;
		}
	
		/**
		 * @public
		 */
		public function getPluginByName(pluginName:String):Plugin{
			for each(var plugin:Plugin in plugins){
				if(plugin.pluginName == pluginName)
					return plugin;
			}
			
			return null;
		}

	}	
}
