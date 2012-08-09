package frameworks.cavalier.ui.components.supportClasses
{
	import frameworks.cavalier.ui.components.skins.PagerSliderThumbSkin;
	import frameworks.crescent.components.Pager;
	
	import spark.components.Button;
	
	public class PagerSliderThumb extends Button
	{
		/**
		 * @public
		 */
		[SkinPart]
		public var pager:Pager;
		
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
			pager.numItems = _numPages;
			invalidateSize();
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
			pager.selectedIndex = _selectedIndex;
			invalidateDisplayList();
		}

		
		/**
		 * Constructor
		 */
		public function PagerSliderThumb()
		{
			super();
			setStyle("skinClass", PagerSliderThumbSkin);
		}
	}
}