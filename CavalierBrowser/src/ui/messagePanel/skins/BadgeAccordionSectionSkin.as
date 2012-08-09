package ui.messagePanel.skins
{
	import frameworks.crescent.skins.AccordionSectionSkin;
	
	import spark.components.Group;
	import spark.components.Scroller;
	
	import ui.messagePanel.supportClasses.BadgeAccordionSection;
	import ui.messagePanel.supportClasses.BadgeAccordionSectionTitleBar;
	
	public class BadgeAccordionSectionSkin extends AccordionSectionSkin
	{
		/**
		 * Constructor
		 */
		public function BadgeAccordionSectionSkin()
		{
			super();
		}
		
		/**
		 * @protected
		 */
		override protected function createChildren():void{
			// Create the title bar first
			titleBar = new BadgeAccordionSectionTitleBar();
			titleBar.title = (hostComponent as BadgeAccordionSection).title;
			addChild(titleBar);	
			
			contentGroup = new Group();
			contentGroup.id = "contentGroup";
			
			scroller = new Scroller();
			
			scroller.setStyle("horizontalScrollPolicy", "off");
			scroller.setStyle("verticalScrollPolicy", "off");
			scroller.viewport = contentGroup;
			addChild(scroller);
		}
	}
}