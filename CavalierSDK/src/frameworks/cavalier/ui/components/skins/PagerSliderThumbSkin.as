package frameworks.cavalier.ui.components.skins
{
	import frameworks.cavalier.ui.components.supportClasses.PagerSliderThumb;
	import frameworks.crescent.components.Pager;
	
	import spark.components.Group;
	import spark.skins.mobile.supportClasses.MobileSkin;
	
	public class PagerSliderThumbSkin extends MobileSkin
	{
		/**
		 * @private
		 */
		public var pager:Pager;
		
		/**
		 * @public
		 */
		public var hostComponent:PagerSliderThumb;
		
		/**
		 * Constructor
		 */
		public function PagerSliderThumbSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Create a pager
			pager = new Pager();
			pager.direction = Pager.HORIZONTAL_DIRECTION;
			addChild(pager);
		}
		
		/**
		 * @private
		 */
		override protected function measure():void
		{
			measuredWidth = pager.measuredWidth;
			measuredHeight = pager.measuredHeight;
		}
		
		/**
		 *  @private 
		 */ 
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			setElementSize(pager, unscaledWidth, unscaledHeight);
			setElementPosition(pager, 0, 0)
		}
		
	}
}