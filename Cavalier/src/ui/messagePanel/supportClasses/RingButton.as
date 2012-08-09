package ui.messagePanel.supportClasses
{
	import spark.components.Button;
	import ui.messagePanel.skins.RingButtonSkin;
	
	public class RingButton extends Button
	{
		/**
		 * Constructor
		 */
		public function RingButton()
		{
			super();
			setStyle("skinClass", RingButtonSkin);
		}
	}
}