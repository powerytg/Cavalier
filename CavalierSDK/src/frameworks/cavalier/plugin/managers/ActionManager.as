package frameworks.cavalier.plugin.managers
{
	import flash.events.EventDispatcher;
	
	import frameworks.cavalier.plugin.Action;
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.ActionDescriptor;
	
	import mx.collections.ArrayCollection;
	
	public class ActionManager extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var allActions:ArrayCollection = new ArrayCollection();
		
		/**
		 * @private
		 */
		private static var _actionManager:ActionManager;
		
		/**
		 * @private
		 */
		public static function get actionManager():ActionManager
		{
			return initialize();
		}
		
		/**
		 * @private
		 */
		public static function initialize():ActionManager
		{
			if (_actionManager == null){
				_actionManager = new ActionManager();
			}
			return _actionManager;
		}
		
		/**
		 * @constructor
		 */
		public function ActionManager()
		{
			super();
			if( _actionManager != null ) throw new Error("Error:ActionManager already initialised.");
			if( _actionManager == null ) _actionManager = this;
		}
		
		/**
		 * @public
		 */
		public function registerAction(desc:ActionDescriptor):void{
			if(!allActions.contains(desc))
				allActions.addItem(desc);
		}
		
		/**
		 * @public
		 */
		public function registerShortcutsFromPlugin(plugin:Plugin):void{
			for each(var desc:ActionDescriptor in plugin.actions){
				registerAction(desc);
			}
		}
		
		/**
		 * @public
		 */
		public function evokeActionByClassName(className:String, localMessageBus:EventDispatcher = null):void{
			for each(var desc:ActionDescriptor in allActions){
				if(desc.actionClassName == className){
					var actionClass:Class = desc.actionClass;
					var action:Action = new actionClass();
					action.doAction(localMessageBus);
					return;
				}
			}
		}
		
		/**
		 * @public
		 */
		public function evokeActionByDescriptor(desc:ActionDescriptor, localMessageBus:EventDispatcher = null):void{
			var actionClass:Class = desc.actionClass;
			var action:Action = new actionClass();
			action.doAction(localMessageBus);
		}
		
		/**
		 * @public
		 */
		public function getActionDescriptorsByModelType(type:String):Array{
			var result:Array = [];
			for each(var desc:ActionDescriptor in allActions){
				if(desc.modelClassName == type){
					result.push(desc);
				}
			}
			
			return result;
		}
		
	}

}