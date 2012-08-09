package plugins.resources.parts.supportClasses
{
	import spark.skins.mobile.ButtonSkin;
	
	public class PlayerChromeSliderThumbSkin extends ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="../images/SliderThumb.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="../images/SliderThumbDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function PlayerChromeSliderThumbSkin()
		{
			super();
			upBorderSkin = upFace;
			downBorderSkin = downFace;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Draw nothing
		}

		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 80;
			measuredHeight = 80;
		}
		
	}
}