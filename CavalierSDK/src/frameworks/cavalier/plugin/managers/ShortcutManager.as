package frameworks.cavalier.plugin.managers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.Shortcut;
	import frameworks.cavalier.plugin.core.ShortcutDescriptor;
	
	import mx.collections.ArrayCollection;
	
	public class ShortcutManager extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var allShortcuts:ArrayCollection = new ArrayCollection();
		
		/**
		 * @public
		 */
		[Bindable]
		public var selectedShortcuts:ArrayCollection = new ArrayCollection();
		
		/**
		 * @private
		 */
		private static var _shortcutManager:ShortcutManager;
		
		/**
		 * @private
		 */
		public static function get shortcutManager():ShortcutManager
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():ShortcutManager
		{
			if (_shortcutManager == null){
				_shortcutManager = new ShortcutManager();
			}
			return _shortcutManager;
		}
		
		/**
		 * @constructor
		 */
		public function ShortcutManager()
		{
			super();
			if( _shortcutManager != null ) throw new Error("Error:ShortcutManager already initialised.");
			if( _shortcutManager == null ) _shortcutManager = this;
		}
		
		/**
		 * @public
		 */
		public function evokeShortcutByClassName(className:String):void{
			for each(var desc:ShortcutDescriptor in allShortcuts){
				if(desc.className == className){
					var shortcutClass:Class = desc.shortcutClass;
					var shortcut:Shortcut = new shortcutClass();
					shortcut.doAction();
					return;
				}
			}
		}
		
		/**
		 * @public
		 */
		public function registerShortcutsFromPlugin(plugin:Plugin):void{
			for each(var desc:ShortcutDescriptor in plugin.shortcuts){
				registerShortcut(desc);
			}
		}
		
		/**
		 * @public
		 */
		public function registerShortcut(desc:ShortcutDescriptor):void{
			if(!allShortcuts.contains(desc))
				allShortcuts.addItem(desc);
			
			if(desc.mandatory && !selectedShortcuts.contains(desc))
				selectedShortcuts.addItem(desc);					
		}
		
	}
}