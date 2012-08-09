package plugins.tracking.activities.supportClasses
{
	import spark.components.supportClasses.ItemRenderer;
	import spark.primitives.BitmapImage;
	
	public class BeaconDistributionMarkerRenderer extends ItemRenderer
	{
		/**
		 * @private
		 */
		[Embed('images/BeaconMarker.png')]
		private var markerFace:Class;
		
		/**
		 * @private
		 */
		private var markerImage:BitmapImage;
		
		/**
		 * Constructor
		 */
		public function BeaconDistributionMarkerRenderer()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override protected function createChildren():void{
			super.createChildren();
			
			markerImage = new BitmapImage();
			markerImage.source = markerFace;
			markerImage.horizontalCenter = 0;
			markerImage.verticalCenter = 0;
			addElement(markerImage);
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredWidth = 25;
			measuredHeight = 28;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
		}
	}
}