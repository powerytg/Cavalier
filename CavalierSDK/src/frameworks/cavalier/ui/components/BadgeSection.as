package frameworks.cavalier.ui.components
{
	import frameworks.cavalier.ui.components.skins.BadgeSectionSkin;
	import frameworks.crescent.components.Section;
	
	
	public class BadgeSection extends Section
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
				(titleBar as BadgeSectionTitleBar).numItems = value;
		}
		
		/**
		 * Constructor
		 */
		public function BadgeSection()
		{
			super();
			setStyle("skinClass", frameworks.cavalier.ui.components.skins.BadgeSectionSkin);
		}
		
		/**
		 * @private
		 */
		override protected function partAdded(partName:String, instance:Object):void{
			super.partAdded(partName, instance);
			
			if(partName == "titleBar")
				(titleBar as BadgeSectionTitleBar).numItems = _numItems;
		}
	}
}