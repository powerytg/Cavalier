package plugins.resources.parts.supportClasses
{
	import spark.components.Button;
	import spark.skins.mobile.HSliderSkin;
	
	public class PlayerChromeSliderSkin extends HSliderSkin
	{
		/**
		 * @private
		 */
		public var highlight:PlayerChromeSliderHighlight;
		
		/**
		 * Constructor
		 */
		public function PlayerChromeSliderSkin()
		{
			super();
			thumbSkinClass = PlayerChromeSliderThumbSkin;
			trackSkinClass = PlayerChromeSliderTrackSkin;
		}

		/**
		 * @private
		 */
		override protected function createChildren():void{
			track = new Button();
			track.setStyle("skinClass", trackSkinClass);
			addChild(track);

			// Create a highlight
			highlight = new PlayerChromeSliderHighlight();
			addChild(highlight);

			thumb = new Button();
			thumb.setStyle("skinClass", thumbSkinClass);
			addChild(thumb);		
		}
		
		/**
		 *  @private
		 */ 
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Layout highlight
			setElementPosition(highlight, 41, track.y + 1);
		}
	}
}