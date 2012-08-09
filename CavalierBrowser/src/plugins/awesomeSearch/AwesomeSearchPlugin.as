package plugins.awesomeSearch
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.UIPartCatagory;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	
	import plugins.awesomeSearch.parts.AwesomeSelector;
	
	public class AwesomeSearchPlugin extends Plugin
	{
		public function AwesomeSearchPlugin(target:IEventDispatcher=null)
		{
			super(target);
			
			_pluginName = "ext search";
			_faceColor = 0xb0d028;
			visible = false;
			
			_uiPartDescriptors.push(new UIPartDescriptor("Smart Selector", null, UIPartCatagory.SELECTOR , AwesomeSelector));
		}
	}
}