package frameworks.cavalier.ui.components.skins
{
	import frameworks.cavalier.ui.components.InfoTile;
	import frameworks.crescent.components.List;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.components.VGroup;
	import spark.components.supportClasses.StyleableTextField;

	public class InfoTileSkin extends ActionTileSkin
	{
		/**
		 * @private
		 */
		protected var titleDisplay:StyleableTextField;
		
		/**
		 * @private
		 */
		protected var contentHolder:Group;
		
		/**
		 * Constructor
		 */
		public function InfoTileSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Create some text nodes
			titleDisplay = new StyleableTextField();
			titleDisplay.selectable = false;
			titleDisplay.setStyle("fontSize", 36);
			titleDisplay.setStyle("color", 0xffffff);
			addChild(titleDisplay);

			// Info list
			var infoContent:IVisualElement = (hostComponent as InfoTile).infoContent;
			contentHolder = new Group();
			
			if(infoContent)
				contentHolder.addElement(infoContent);
			
			addChild(contentHolder);
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			
			titleDisplay.text = (hostComponent as InfoTile).title;			
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			titleDisplay.x = unscaledWidth - titleDisplay.getPreferredBoundsWidth() - 10;
			titleDisplay.y = unscaledHeight - titleDisplay.getPreferredBoundsHeight() - 20;

			contentHolder.x = unscaledWidth - contentHolder.measuredWidth - 10;
			contentHolder.y = 10;
		}
		
		/**
		 * @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			titleDisplay.commitStyles();
		}
		
	}
}