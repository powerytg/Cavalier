package plugins.resources.parts.supportClasses
{
	import flash.geom.Point;
	
	import spark.components.HSlider;
	
	public class PlayerChromeSlider extends HSlider
	{
		/**
		 * @public
		 */
		[SkinPart]
		public var highlight:PlayerChromeSliderHighlight;
		
		/**
		 * Constructor
		 */
		public function PlayerChromeSlider()
		{
			super();
			setStyle("skinClass", PlayerChromeSliderSkin);
		}
		
		/**
		 *  @private
		 */
		override protected function updateSkinDisplayList():void
		{
			if (!thumb || !track)
				return;
			
			var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
			var range:Number = maximum - minimum;
			
			// calculate new thumb position.
			var thumbPosTrackX:Number = (range > 0) ? ((pendingValue - minimum) / range) * thumbRange : 0;
			
			// convert to parent's coordinates.
			var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX, 0));
			var thumbPosParentX:Number = thumb.parent.globalToLocal(thumbPos).x;
			
			thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX), thumb.getLayoutBoundsY());
			
			// Margin the highlight
			highlight.setLayoutBoundsSize(thumbPosParentX, track.getPreferredBoundsHeight() - 2);
		}
		
	}
}