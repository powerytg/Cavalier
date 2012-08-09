package plugins.resources.parts.supportClasses
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class PlayerChromeSliderHighlight extends SkinnableComponent
	{
		/**
		 * Constructor
		 */
		public function PlayerChromeSliderHighlight()
		{
			super();
			setStyle("skinClass", PlayerChromeSliderHighlightSkin);
		}
	}
}