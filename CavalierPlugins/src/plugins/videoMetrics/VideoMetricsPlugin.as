package plugins.videoMetrics
{
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.plugin.Plugin;
	import frameworks.cavalier.plugin.core.UIPartCatagory;
	import frameworks.cavalier.plugin.core.UIPartDescriptor;
	
	import plugins.videoMetrics.parts.BitrateChartWidget;
	import plugins.videoMetrics.parts.FramerateChartWidget;
	import plugins.videoMetrics.parts.OSMFInfoWidget;
	
	public class VideoMetricsPlugin extends Plugin
	{
		public function VideoMetricsPlugin(target:IEventDispatcher=null)
		{
			super(target);
			
			visible = false;
			_pluginName = "video metrics";
			_faceColor = 0x214836;
			
			_uiPartDescriptors.push(new UIPartDescriptor("OSMF Status", null, UIPartCatagory.ANALYSIS , OSMFInfoWidget));
			_uiPartDescriptors.push(new UIPartDescriptor("Frame Rate", null, UIPartCatagory.ANALYSIS , FramerateChartWidget));
			_uiPartDescriptors.push(new UIPartDescriptor("Bit Rate / Buffer", null, UIPartCatagory.ANALYSIS , BitrateChartWidget));
		}
	}
}