package frameworks.cavalier.ui.components.skins
{
	import frameworks.crescent.skins.CircularButtonSkin;
	
	public class PopOutButtonSkin extends CircularButtonSkin
	{
		/**
		 * Up skin
		 */
		[Embed(source="images/PopOut.png")]
		protected var upImg:Class;
		
		/**
		 * Down skin
		 */
		[Embed(source="images/PopOutDown.png")]
		protected var downImg:Class;

		/**
		 * Constructor
		 */
		public function PopOutButtonSkin()
		{
			super();
			upBorderSkin = upImg;
			downBorderSkin = downImg;
		}
	}
}