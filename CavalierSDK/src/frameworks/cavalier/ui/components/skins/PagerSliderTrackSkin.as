package frameworks.cavalier.ui.components.skins
{
	import spark.skins.mobile.HSliderTrackSkin;
	
	public class PagerSliderTrackSkin extends HSliderTrackSkin
	{
		/**
		 * @private
		 */
		[Embed(source='images/PagerSliderTrack.png', scaleGridLeft="15", scaleGridRight="30", scaleGridTop="6", scaleGridBottom="20")]
		private var face:Class;
		
		/**
		 * Constructor
		 */
		public function PagerSliderTrackSkin()
		{
			super();
			trackClass = face;
			trackHeight = 25;
		}
		
		/**
		 * @private
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			// Draw nothing
		}
		
	}
}