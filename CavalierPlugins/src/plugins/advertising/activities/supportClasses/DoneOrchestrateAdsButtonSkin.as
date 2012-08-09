package plugins.advertising.activities.supportClasses
{
	import flash.display.DisplayObject;
	
	import spark.components.Group;
	import spark.components.ResizeMode;
	import spark.primitives.BitmapImage;
	import spark.skins.mobile.ButtonSkin;
	
	public class DoneOrchestrateAdsButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/InsertAdButtonBackground.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/InsertAdButtonBackgroundDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function DoneOrchestrateAdsButtonSkin()
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
		
	}
}