package plugins.resources.parts.supportClasses
{
	import flash.display.Bitmap;
	
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class PlayerChromeSliderHighlightSkin extends MobileSkin
	{
		/**
		 * @private
		 */
		[Embed('../images/SliderPattern.png')]
		private var pattern:Class;
		
		/**
		 * @private
		 */
		private var patternBitmap:Bitmap = new pattern();
		
		/**
		 * Constructor
		 */
		public function PlayerChromeSliderHighlightSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			graphics.clear();
			graphics.beginFill(0x00a6ed);
			graphics.drawRoundRect(1, 1, unscaledWidth - 2, unscaledHeight - 2, 15, 15);
			graphics.endFill();
			
			// Draw pattern
			graphics.beginBitmapFill(patternBitmap.bitmapData);
			graphics.drawRoundRect(1, 1, unscaledWidth - 2, unscaledHeight - 2, 15, 15);
			graphics.endFill();
		}
		
	}
}