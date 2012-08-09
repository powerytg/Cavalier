package ui.messagePanel.skins
{
	import flash.display.DisplayObject;
	
	import frameworks.crescent.skins.AccordionTitleBarSkin;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.supportClasses.StyleableTextField;
	import spark.primitives.BitmapImage;
	
	import ui.messagePanel.supportClasses.BadgeAccordionSectionTitleBar;
	
	public class BadgeAccordionSectionTitleBarSkin extends AccordionTitleBarSkin
	{
		/**
		 * @public
		 */
		public var numericDisplay:Label;
		
		/**
		 * A background
		 */
		[Embed(source="images/AccordionSectionTitleBar.png")]
		private var fillFace:Class;

		/**
		 * Badget icon
		 */
		[Embed(source="images/Badget.png")]
		private var badgetFace:Class;

		/**
		 * @private
		 */
		private var background:DisplayObject;

		/**
		 * @private
		 */
		private var badget:BitmapImage;

		/**
		 * @private
		 */
		public var badgetGroup:Group;
		
		/**
		 * Constructor
		 */
		public function BadgeAccordionSectionTitleBarSkin()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			// Create background
			background = new fillFace();
			addChild(background);
			
			// Create a title
			titleDisplay = new StyleableTextField();
			titleDisplay.selectable = false;
			titleDisplay.setStyle("fontSize", 24);
			titleDisplay.setStyle("fontFamily", "Walkway SemiBold");
			titleDisplay.setStyle("color", 0x87b0e7);
			
			addChild(titleDisplay);
			
			// Create a badget
			badgetGroup = new Group();
			badgetGroup.width = 46;
			badgetGroup.height = 47;
			addChild(badgetGroup);
			
			badget = new BitmapImage();
			badget.source = badgetFace;
			badgetGroup.addElement(badget);
			
			numericDisplay = new Label();
			numericDisplay.setStyle("fontFamily", "Myriad Pro");
			numericDisplay.setStyle("color", 0x0e5955);
			numericDisplay.setStyle("fontSize", 24);
			numericDisplay.setStyle("fontWeight", "normal");
			numericDisplay.horizontalCenter = 0;
			numericDisplay.verticalCenter = 0;
			
			badgetGroup.addElement(numericDisplay);
		}
		
		/**
		 * @private
		 */
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutContents(unscaledWidth, unscaledHeight);
			
			// Background
			setElementSize(background, unscaledWidth, 63);
			
			// Title
			titleDisplay.x = 30;
			titleDisplay.y = 5;
			
			// Badget
			badgetGroup.x = unscaledWidth -badgetGroup.width - 5;
			badgetGroup.y = 18;
		}
		
		/**
		 * @private
		 */
		override protected function commitProperties():void{
			super.commitProperties();
			numericDisplay.text = (hostComponent as BadgeAccordionSectionTitleBar).numItems.toString();
		}

		
		/**
		 * @protected
		 */
		override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void{
			titleDisplay.commitStyles();	
		}
	}
}