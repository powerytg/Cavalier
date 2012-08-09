package plugins.annotations
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	
	public class AnnotationPlugin extends Plugin
	{
		/**
		 * Constructor
		 */
		public function AnnotationPlugin(target:IEventDispatcher=null)
		{
			super(target);
			_faceColor = 0x5e0245;
			_pluginName = "annotation";
			visible = false;
		}
	}
}