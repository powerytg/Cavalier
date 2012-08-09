package plugins.advertising.activities.supportClasses
{
	import flash.display.DisplayObject;
	
	import spark.components.Group;
	import spark.components.ResizeMode;
	import spark.skins.mobile.ButtonSkin;
	
	public class InsertAdsButtonSkin extends spark.skins.mobile.ButtonSkin
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
		 * @private
		 */
		[Embed(source="images/InsertAdIcon.png")]
		private var iconFace:Class;
		
		/**
		 * Constructor
		 */
		public function InsertAdsButtonSkin()
		{
			super();
			upBorderSkin = upFace;
			downBorderSkin = downFace;
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			addChild(new iconFace());
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