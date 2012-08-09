package frameworks.cavalier.plugin.managers
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	import frameworks.cavalier.ui.parts.UIPart;
	
	import mx.collections.ArrayCollection;
	
	public class UIPartManager extends EventDispatcher
	{
		/**
		 * @public
		 * 
		 * All the available ui parts. This is a dictionary with catagory
		 * as key and an ArrayCollection of UIPartDescriptor as value
		 */
		[Bindable]
		public var parts:Dictionary = new Dictionary();
		
		/**
		 * @public
		 */
		private static var _uiPartManager:UIPartManager;
		
		/**
		 * @public
		 */
		public static function get uiPartManager():UIPartManager
		{
			return initialize();
		}
		
		/**
		 * @public
		 */
		public static function initialize():UIPartManager
		{
			if (_uiPartManager == null){
				_uiPartManager = new UIPartManager();
			}
			return _uiPartManager;
		}
		
		/**
		 * Constructor
		 */
		public function UIPartManager()
		{
			super();
			if( _uiPartManager != null ) throw new Error("Error:UIPartManager already initialised.");
			if( _uiPartManager == null ) _uiPartManager = this;
		}
		
		/**
		 * @public
		 */
		public function registerUIPartsFromPlugin(plugin:Plugin):void{
			for each(var desc:UIPartDescriptor in plugin.uiParts){
				registerUIPart(desc);
			}
		}
		
		/**
		 * @public
		 */
		public function registerUIPart(descriptor:UIPartDescriptor):void{
			var collection:ArrayCollection;
			
			if(!parts.hasOwnProperty(descriptor.catagory)){
				collection = new ArrayCollection();
				parts[descriptor.catagory] = collection;
			}
			else
				collection = parts[descriptor.catagory] as ArrayCollection;
			
			collection.addItem(descriptor);
		}
	
		/**
		 * @public
		 */
		public function requestUIPartByClassName(className:String):UIPart{
			try{
				var partClass:Class = flash.utils.getDefinitionByName(className) as Class;
			}
			catch(e:ReferenceError){
				return null;
			}
			
			var part:UIPart = new partClass();
			return part;
		}
		
	}
}
