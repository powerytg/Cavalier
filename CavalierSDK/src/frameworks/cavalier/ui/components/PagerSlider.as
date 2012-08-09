package frameworks.cavalier.ui.components
{
	import frameworks.cavalier.ui.components.supportClasses.PagerSliderThumb;
	
	import spark.components.HSlider;
	
	public class PagerSlider extends HSlider
	{
		/**
		 * @public
		 */
		[SkinPart]
		public var pager:PagerSliderThumb;
		
		/**
		 * Constructor
		 */
		public function PagerSlider()
		{
			super();
		}

		/**
		 * @private
		 */
		private var _selectedIndex:Number;
		
		/**
		 * @private
		 */
		public function get selectedIndex():Number
		{
			return _selectedIndex;
		}
		
		/**
		 * @private
		 */
		public function set selectedIndex(value:Number):void
		{
			_selectedIndex = value;
			if(pager)
				pager.selectedIndex = _selectedIndex;
		}
		
		/**
		 * @private
		 */
		private var _numPages:Number;
		
		/**
		 * @public
		 */
		public function get numPages():Number
		{
			return _numPages;
		}

		/**
		 * @private
		 */
		public function set numPages(value:Number):void
		{
			_numPages = value;
			
			if(pager)
				pager.numPages = _numPages;
		}
		
	}
}