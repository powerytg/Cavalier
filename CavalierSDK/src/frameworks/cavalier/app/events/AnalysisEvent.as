package frameworks.cavalier.app.events
{
	import flash.events.Event;
	
	import frameworks.cavalier.app.models.stat.ClipAnalysisResult;
	
	import mx.collections.ArrayCollection;
	
	public class AnalysisEvent extends Event
	{
		public static const CLIP_HITS_CHANGE:String = "clipHitsChange";
		public static const CDN_UPTIME_CHANGE:String = "cdnUpTimeChange";
		public static const DB_USAGE_CHANGE:String = "dbUsageChange";
		public static const DB_USAGE_FOR_CLIP_CHANGE:String = "dbUsageForClipChange";
		
		[Bindable]
		public var clipHits:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var cdnUsage:ArrayCollection = new ArrayCollection();
				
		[Bindable]
		public var dbUsage:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var clipUsage:ClipAnalysisResult;
		
		public function AnalysisEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}