package frameworks.cavalier.plugin.core
{
	public class UIPartCatagory
	{
		/**
		 * @public
		 */
		public static const COMMON:String = "common";

		/**
		 * @public
		 */
		public static const CALENDAR:String = "calendar";

		/**
		 * @public
		 */
		public static const SELECTOR:String = "selector";

		/**
		 * @public
		 */
		public static const EDITOR:String = "editor";

		/**
		 * @public
		 */
		public static const ANALYSIS:String = "analysis";

		//////////////////////////////////////////////////////////////////////////////
		//
		// Icons
		//
		//////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @public
		 */
		public static function getCatatoryIcon(cat:String):Class{
			var icon:Class;
			
			switch(cat){
				case COMMON:
					icon =  CALENDAR_ICON;
					break;
				case CALENDAR:
					icon =  CALENDAR_ICON;
					break;
				case SELECTOR:
					icon =  SELECTOR_ICON;
					break;
				case EDITOR:
					icon =  EDITOR_ICON;
					break;
				case ANALYSIS:
					icon =  ANALYSIS_ICON;
					break;

			}
			
			return icon;
		}
		
		/**
		 * @public
		 */
		public static function getCatatoryColor(cat:String):Number{
			var color:Number;
			
			switch(cat){
				case COMMON:
					color =  0x696969;
					break;
				case CALENDAR:
					color =  0x588192;
					break;
				case SELECTOR:
					color =  0;
					break;
				case EDITOR:
					color =  0x99ff99;
					break;
				case ANALYSIS:
					color = 0xff387a;
					break;
			}
			
			return color;
		}
		
		/**
		 * @public
		 */
		[Embed(source="frameworks/cavalier/ui/parts/skins/images/Calendar.png")]
		public static var CALENDAR_ICON:Class;

		/**
		 * @public
		 */
		[Embed(source="frameworks/cavalier/ui/parts/skins/images/Editor.png")]
		public static var EDITOR_ICON:Class;

		/**
		 * @public
		 */
		[Embed(source="frameworks/cavalier/ui/parts/skins/images/Selector.png")]
		public static var SELECTOR_ICON:Class;

		/**
		 * @public
		 */
		[Embed(source="frameworks/cavalier/ui/parts/skins/images/Analysis.png")]
		public static var ANALYSIS_ICON:Class;

		/**
		 * Constructor
		 */
		public function UIPartCatagory()
		{
		}
	}
}