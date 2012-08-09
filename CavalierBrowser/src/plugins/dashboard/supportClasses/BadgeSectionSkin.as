package plugins.dashboard.supportClasses
{
	import frameworks.crescent.skins.SectionSkin;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Scroller;
	
	
	public class BadgeSectionSkin extends SectionSkin
	{
		/**
		 * Constructor
		 */
		public function BadgeSectionSkin()
		{
			super();
		}
		
		/**
		 * @protected
		 */
		override protected function createChildren():void{
			// Create the title bar first
			titleBar = new BadgeSectionTitleBar();
			titleBar.title = (hostComponent as BadgeSection).title;
			addChild(titleBar);	
			
			contentGroup = new Group();
			addChild(contentGroup);			
			
			actionHolder = new Group();
			addChild(actionHolder);
			
			actionGroup = new HGroup();
			actionGroup.verticalAlign = "middle";
			actionGroup.horizontalAlign = "right";
			actionHolder.addElement(actionGroup);
		}
	}
}