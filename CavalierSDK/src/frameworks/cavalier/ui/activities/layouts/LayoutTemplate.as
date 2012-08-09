package frameworks.cavalier.ui.activities.layouts
{
	import flash.events.EventDispatcher;

	public class LayoutTemplate extends EventDispatcher
	{
		/**
		 * @public
		 */
		[Bindable]
		public var icon:Class;
		
		/**
		 * @public
		 */
		public var templateClass:Class;
		
		/**
		 * Constructor
		 */
		public function LayoutTemplate()
		{
			super(null);
		}
	}
}