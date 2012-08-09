package frameworks.cavalier.ui.components
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Preview extends SkinnableComponent
	{
		/**
		 * @public
		 */
		[Bindable]
		public var source:Object;
		
		/**
		 * Constructor
		 */
		public function Preview()
		{
			super();
			cacheAsBitmap = true;
		}
		
		/**
		 * @private
		 */
		override protected function measure():void{
			super.measure();
			measuredWidth = 100;
			measuredHeight = 60;
		}
	}
}