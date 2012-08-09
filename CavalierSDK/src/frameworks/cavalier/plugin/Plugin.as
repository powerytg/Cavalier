package frameworks.cavalier.plugin
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.core.ActionDescriptor;
	import frameworks.cavalier.plugin.core.ActivityDescriptor;
	import frameworks.cavalier.plugin.core.IPlugin;
	import frameworks.cavalier.plugin.core.ShortcutDescriptor;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	import frameworks.cavalier.plugin.events.PluginEvent;
	
	public class Plugin extends EventDispatcher implements IPlugin
	{
		/**
		 * @private
		 */
		protected var _pluginName:String = "Plugin";
		
		/**
		 * @private
		 */
		protected var _description:String = "Description unavailable";
		
		/**
		 * @private
		 */
		protected var _faceColor:Number = 0x999999;

		/**
		 * @public
		 * 
		 * The activities that is always visible on the dashboard
		 */
		public var mandatoryActivities:Vector.<Class> = new Vector.<Class>();
		
		/**
		 * @private
		 */
		protected var _activityDescriptors:Vector.<ActivityDescriptor> = new Vector.<ActivityDescriptor>();
		
		/**
		 * @private
		 */
		protected var _uiPartDescriptors:Vector.<UIPartDescriptor> = new Vector.<UIPartDescriptor>();
		
		/**
		 * @private
		 */
		protected var _shortcutDescriptors:Vector.<ShortcutDescriptor> = new Vector.<ShortcutDescriptor>();
		
		/**
		 * @private
		 */
		protected var _actionDescriptors:Vector.<ActionDescriptor> = new Vector.<ActionDescriptor>();		
		
		/**
		 * @public
		 */
		public var visible:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function Plugin(target:IEventDispatcher = null)
		{
			super(target);
		}
		
		/**
		 * @public
		 */
		public function get activities():Vector.<ActivityDescriptor>
		{
			return _activityDescriptors;
		}
		
		/**
		 * @public
		 */
		public function get uiParts():Vector.<UIPartDescriptor>{
			return _uiPartDescriptors;
		}
			
		/**
		 * @public
		 */
		public function get shortcuts():Vector.<ShortcutDescriptor>{
			return _shortcutDescriptors;
		}
		
		/**
		 * @public
		 */
		public function get actions():Vector.<ActionDescriptor>{
			return _actionDescriptors;
		}		
		
		/**
		 * @public
		 */
		public function get faceColor():Number
		{
			return _faceColor;
		}
		
		/**
		 * @public
		 */
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * @public
		 */
		public function get pluginName():String{
			return _pluginName;
		}
		
		/**
		 * @public
		 * 
		 * Execute a chain of initialization actions
		 */
		public function initialize():void{
			// Loading is complete
			var loadEvent:PluginEvent = new PluginEvent(PluginEvent.LOADED);
			loadEvent.plugin = this;
			dispatchEvent(loadEvent);

			// Do pre-initialize
			preInitialize();
		}
		
		/**
		 * @protected
		 */
		protected function preInitialize():void{
			// Loading is complete
			var evt:PluginEvent = new PluginEvent(PluginEvent.INITIALIZED);
			evt.plugin = this;
			dispatchEvent(evt);

			// Do your initialization here
		}
		
		/**
		 * @public
		 */
		public function getActivityDescriptorByClass(activityClass:Class):ActivityDescriptor{
			for each(var desc:ActivityDescriptor in _activityDescriptors){
				if(desc.activityClass == activityClass)
					return desc;
			}
			
			return null;
		}
		
		/**
		 * @public
		 */
		public function getActivityDescriptorByClassName(className:String):ActivityDescriptor{
			for each(var desc:ActivityDescriptor in _activityDescriptors){
				if(desc.className == className)
					return desc;
			}
			
			return null;
		}

		/**
		 * @public
		 */
		public function getShortcutDescriptorByClassName(className:String):ShortcutDescriptor{
			for each(var desc:ShortcutDescriptor in _shortcutDescriptors){
				if(desc.className == className)
					return desc;
			}
			
			return null;
		}

	}
}