package frameworks.cavalier.ui.components.skins
{
	import frameworks.cavalier.ui.components.supportClasses.PagerSliderThumb;
	import frameworks.crescent.components.Pager;
	
	import mx.core.ClassFactory;
	
	import spark.components.Button;
	import spark.skins.mobile.HSliderSkin;
	
	public class PagerSliderSkin extends HSliderSkin
	{
		/**
		 * @private
		 */
		public var pager:PagerSliderThumb;
		
		/**
		 * Constructor
		 */
		public function PagerSliderSkin()
		{
			super();
			trackSkinClass = PagerSliderTrackSkin;
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			track = new Button();
			track.setStyle("skinClass", trackSkinClass);
			addChild(track);
			
			thumb = new PagerSliderThumb();
			addChild(thumb);
			pager = thumb as PagerSliderThumb;
			
			// Set up the class factory for the dataTip
			dataTip = new ClassFactory();
			ClassFactory(dataTip).generator = dataTipClass;
		}
	
	}
	
}