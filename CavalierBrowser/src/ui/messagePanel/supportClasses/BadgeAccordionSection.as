package ui.messagePanel.supportClasses
{
	import frameworks.crescent.components.AccordionSection;
	
	import ui.messagePanel.skins.BadgeAccordionSectionSkin;
	
	public class BadgeAccordionSection extends AccordionSection
	{
		/**
		 * @private
		 */
		private var _numItems:Number;

		/**
		 * @public
		 */
		[Bindable]
		public function get numItems():Number
		{
			return _numItems;
		}

		/**
		 * @private
		 */
		public function set numItems(value:Number):void
		{
			_numItems = value;
			if(titleBar)
				(titleBar as BadgeAccordionSectionTitleBar).numItems = value;
		}

		/**
		 * Constructor
		 */
		public function BadgeAccordionSection()
		{
			super();
			setStyle("skinClass", BadgeAccordionSectionSkin);
		}
		
		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(partName == "titleBar")
				(titleBar as BadgeAccordionSectionTitleBar).numItems = _numItems;
		}
	}
}