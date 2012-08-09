package plugins.annotations.activities.supportClasses
{
	import spark.skins.mobile.ButtonSkin;
	
	public class PlayButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		/**
		 * @private
		 */
		[Embed(source="images/PlayButton.png")]
		private var upBackground:Class;
		
		/**
		 * @private
		 */
		[Embed(source="images/PlayButtonDown.png")]
		private var downBackground:Class;
		
		/**
		 * Constructor
		 */
		public function PlayButtonSkin()
		{
			super();
			upBorderSkin = upBackground;
			downBorderSkin = downBackground;
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 61;
			measuredHeight = 60;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw nothing
		}
		
	}
}