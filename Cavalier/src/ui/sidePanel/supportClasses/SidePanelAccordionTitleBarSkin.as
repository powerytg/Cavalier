package ui.sidePanel.supportClasses
{
	import flash.display.DisplayObject;
	
	import frameworks.crescent.skins.AccordionTitleBarSkin;
	
	public class SidePanelAccordionTitleBarSkin extends AccordionTitleBarSkin
	{
		/**
		 * A small icon
		 */
		[Embed(source="ui/sidePanel/images/Item.png")]
		private var iconFace:Class;
		
		/**
		 * @private
		 */
		private var icon:DisplayObject;
		
		/**
		 * Constructor
		 */
		public function SidePanelAccordionTitleBarSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			// Create an icon
			icon = new iconFace();
			addChild(icon);
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			icon.x = 10;
			icon.y = unscaledHeight / 2 - 4;
			
			titleDisplay.x = 25;
		}
		
	}
}