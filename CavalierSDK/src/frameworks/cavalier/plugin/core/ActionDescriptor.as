package frameworks.cavalier.plugin.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ActionDescriptor extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var modelClassName:String;
		
		/**
		 * @public
		 */
		public var actionClassName:String;
		
		/**
		 * @public
		 */
		public var actionClass:Class;		
		
		/**
		 * @public
		 */
		public var title:String;
		
		/**
		 * @public
		 */
		public var icon:Class;
		
		/**
		 * @public
		 */
		public var useRedButton:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function ActionDescriptor(_modelType:String, _actionClassName:String, _actionClass:Class, _title:String, _icon:Class = null, _useRedButton:Boolean = false)
		{
			super(null);
			
			modelClassName = _modelType;
			actionClassName = _actionClassName;
			actionClass = _actionClass;
			title = _title;
			icon = _icon;
			useRedButton = _useRedButton;
		}
	}
}