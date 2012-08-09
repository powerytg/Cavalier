package plugins.advertising.activities.supportClasses
{
	import flash.display.DisplayObject;
	
	import spark.components.Group;
	import spark.components.ResizeMode;
	import spark.skins.mobile.ButtonSkin;
	
	public class OrchestrateButtonSkin extends spark.skins.mobile.ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/OrchestrateButton.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/OrchestrateButtonDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function OrchestrateButtonSkin()
		{
			super();
			upBorderSkin = upFace;
			downBorderSkin = downFace;
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			measuredWidth = 80;
			measuredHeight = 80;
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