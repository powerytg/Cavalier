package frameworks.cavalier.app.models.stat
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.models.Clip;
	
	public class ClipAnalysisResult extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var heatmapPercentage:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var trackingClipPercentage:Number;
		
		/**
		 * Constructor
		 */
		public function ClipAnalysisResult(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}