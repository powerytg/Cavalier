package frameworks.cavalier.plugin.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.ui.parts.UIPart;
	
	/**
	 * A simple description attached with an UIPart
	 */
	public class UIPartDescriptor extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var partName:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var icon:Class;
		
		/**
		 * @public
		 */
		[Bindable]
		public var catagory:String;
		
		/**
		 * @public
		 */
		[Bindable]
		public var partClass:Class;
		
		/**
		 * Constructor
		 */
		public function UIPartDescriptor(_partName:String = "UI Part", 
										 _icon:Class = null, 
										 _catagory:String = UIPartCatagory.COMMON, 
										 _partClass:Class = null, 
										 target:IEventDispatcher=null)
		{
			super(target);
			
			partName = _partName;
			icon = _icon;
			catagory = _catagory;
			partClass = _partClass;
		}
	}
}