package frameworks.cavalier.ui.components.skins
{
	import frameworks.cavalier.ui.components.ActionTile;
	import frameworks.crescent.skins.TileSkin;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	
	public class ActionTileSkin extends TileSkin
	{
		/**
		 * @private
		 */
		[Embed(source="images/ActionTriangle.png")]
		private var arrow:Class;
		
		/**
		 * @private
		 */
		private var iconDisplay:BitmapImage;
		
		/**
		 * @private
		 */
		private var iconHolder:Group;
		
		/**
		 * Constructor
		 */
		public function ActionTileSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Add a black trangle
			addChild(new arrow());
			
			// Add an icon
			iconHolder = new Group();
			iconHolder.mouseChildren = false;
			iconHolder.mouseEnabled = false;
			iconDisplay = new BitmapImage();
			iconHolder.addElement(iconDisplay);
			addChild(iconHolder);
			
			if((hostComponent as ActionTile).icon)
				iconDisplay.source = (hostComponent as ActionTile).icon;
		}
		
		/**
		 *  @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			iconHolder.validateNow();
			setElementPosition(iconHolder, unscaledWidth - iconDisplay.width - 10, unscaledHeight - iconDisplay.height - 10);
		}
	}
}