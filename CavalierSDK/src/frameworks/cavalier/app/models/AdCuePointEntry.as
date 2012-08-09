package frameworks.cavalier.app.models
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import frameworks.cavalier.app.utils.ColorUtils;
	import frameworks.cavalier.ui.components.supportClasses.ITimelineMarkerMetadata;
	
	public class AdCuePointEntry extends EventDispatcher implements ITimelineMarkerMetadata
	{
		/**
		 * @public
		 */
		[Bindable]
		public var ad:Ad;
		
		/**
		 * @public
		 */
		[Bindable]
		public var cuePoint:Number;
		
		/**
		 * @public
		 */
		[Bindable]
		public var color:Number = 0;		
		
		/**
		 * Constructor
		 */
		public function AdCuePointEntry(target:IEventDispatcher=null)
		{
			super(target);
			color = ColorUtils.getRandomColor();
		}
		
		/**
		 * @public
		 */
		public function get length():Number
		{
			// Roughly calculate a "duration" based on the length of the ad name
			var maxLength:Number = 60;
			return Math.min(maxLength, ad.name.length * 5);
		}
				
		/**
		 * @public
		 */
		public function get time():Number
		{
			return cuePoint;
		}
		
	}
}