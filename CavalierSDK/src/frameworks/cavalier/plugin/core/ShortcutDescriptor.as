package frameworks.cavalier.plugin.core
{
	import flash.events.EventDispatcher;
	
	public class ShortcutDescriptor extends EventDispatcher
	{
		/**
		 * @public
		 */
		public var className:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var description:String = "description unavailable";
		
		/**
		 * @public
		 */
		public var shortcutClass:Class;
		
		/**
		 * @public
		 */
		[Bindable]
		public var mandatory:Boolean = false;
		
		/**
		 * @public
		 */
		[Bindable]
		public var icon:Class;
		
		/**
		 * Constructor
		 */
		public function ShortcutDescriptor(_mandatory:Boolean, _description:String, _icon:Class, _shortcutClass:Class, _className:String)
		{
			super(null);
			
			className = _className;
			description = _description;
			shortcutClass = _shortcutClass;
			icon = _icon;
			mandatory = _mandatory;
		}
	}
}