package frameworks.cavalier.plugin.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ActivityDescriptor extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var activityName:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var activityClass:Class;
		
		/**
		 * @public
		 */
		[Bindable]
		public var className:String;
		
		/**
		 * @public
		 */
		public var visible:Boolean;
		
		/**
		 * Constructor
		 */
		public function ActivityDescriptor(_name:String = null, 
										   _class:Class = null, 
										   _className:String = null,
										   _visible:Boolean = true)
		{
			super();
			
			activityName = _name;
			activityClass = _class;
			className = _className;
			visible = _visible;
		}
	}
}