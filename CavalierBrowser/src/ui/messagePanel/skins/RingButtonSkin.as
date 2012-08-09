package ui.messagePanel.skins
{
	import spark.skins.mobile.ButtonSkin;
	
	public class RingButtonSkin extends ButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/RingButton.png")]
		protected var upFace:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/RingButtonDown.png")]
		protected var downFace:Class;
		
		/**
		 * Constructor
		 */
		public function RingButtonSkin()
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
		 * @protected
		 */
		override protected function measure():void{
			super.measure();
			measuredWidth = 83;
			measuredHeight = 204;
		}
	}
}