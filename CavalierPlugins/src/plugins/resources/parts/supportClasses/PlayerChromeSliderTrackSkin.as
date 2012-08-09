package plugins.resources.parts.supportClasses
{
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class PlayerChromeSliderTrackSkin extends MobileSkin
	{
		/**
		 * Constructor
		 */
		public function PlayerChromeSliderTrackSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredHeight = 15;
		}
		
		/**
		 *  @private 
		 */ 
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			graphics.beginFill(0x000000, 0.6);
			graphics.drawRoundRect(40, 0, unscaledWidth - 80, unscaledHeight, 15, 15);
			graphics.endFill();
		}

	}
}